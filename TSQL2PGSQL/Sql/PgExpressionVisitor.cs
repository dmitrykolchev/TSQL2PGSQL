using System;
using System.Text;
using DykBits.Sql.ObjectModel;
using Microsoft.SqlServer.TransactSql.ScriptDom;

namespace DykBits.Sql
{
    class PgExpressionVisitor : TSqlFragmentVisitor
    {
        private StringBuilder _buffer;
        private PgTable _table;
        public PgExpressionVisitor(StringBuilder buffer)
        {
            _buffer = buffer;
        }
        public PgExpressionVisitor(StringBuilder buffer, PgTable table)
        {
            _buffer = buffer;
            _table = table;
        }
        public override void ExplicitVisit(ExecuteStatement node)
        {
            base.ExplicitVisit(node);
        }
        public override void ExplicitVisit(SetIdentityInsertStatement node)
        {
            _buffer.AppendLine();
            _buffer.Append("-- set identity_insert ");
            node.Table.Accept(this);
            _buffer.Append(node.IsOn ? " on" : " off");
            _buffer.AppendLine();
        }
        public override void ExplicitVisit(Identifier node)
        {
            if (node.QuoteType != QuoteType.NotQuoted)
            {
                _buffer.Append("\"" + node.Value + "\"");
            }
            else
            {
                _buffer.Append(node.Value);
            }
        }
        public override void ExplicitVisit(MultiPartIdentifier node)
        {
            for (int index = 1; index <= node.Identifiers.Count; ++index)
            {
                node.Identifiers[node.Identifiers.Count - index].Accept(this);
                if (index != node.Identifiers.Count)
                {
                    _buffer.Append(".");
                }
            }
        }
        public override void ExplicitVisit(SchemaObjectName node)
        {
            for (int index = 0; index < node.Identifiers.Count; ++index)
            {
                node.Identifiers[index].Accept(this);
                if (index < node.Identifiers.Count - 1)
                {
                    _buffer.Append(".");
                }
            }
        }
        public override void ExplicitVisit(ForeignKeyConstraintDefinition node)
        {
            if (node.ConstraintIdentifier != null)
            {
                node.ConstraintIdentifier.Accept(this);
            }
            _buffer.Append(" foreign key (");
            for (int index = 0; index < node.Columns.Count; ++index)
            {
                node.Columns[index].Accept(this);
                if (index < node.Columns.Count - 1)
                {
                    _buffer.Append(", ");
                }
            }
            _buffer.Append(") references ");
            node.ReferenceTableName.Accept(this);
            _buffer.Append(" (");
            for (int index = 0; index < node.ReferencedTableColumns.Count; ++index)
            {
                node.ReferencedTableColumns[index].Accept(this);
                if (index < node.ReferencedTableColumns.Count - 1)
                {
                    _buffer.Append(", ");
                }
            }
            _buffer.Append(")");
        }
        public override void ExplicitVisit(ColumnWithSortOrder node)
        {
            node.Column.MultiPartIdentifier.Accept(this);
        }
        public override void ExplicitVisit(UniqueConstraintDefinition node)
        {
            if (node.ConstraintIdentifier != null)
            {
                _buffer.Append("constraint ");
                node.ConstraintIdentifier.Accept(this);
            }
            if (node.IsPrimaryKey)
            {
                _buffer.Append(" primary key (");
            }
            else
            {
                _buffer.Append(" unique (");
            }
            for (int index = 0; index < node.Columns.Count; ++index)
            {
                node.Columns[index].Accept(this);
                if (index < node.Columns.Count - 1)
                {
                    _buffer.Append(", ");
                }
            }
            _buffer.Append(")");
        }

        public override void ExplicitVisit(CheckConstraintDefinition node)
        {
            if (node.ConstraintIdentifier != null)
            {
                node.ConstraintIdentifier.Accept(this);
            }
            else
            {
                _buffer.Append($"\"check_{Guid.NewGuid().ToString("N").ToLower()}\"");
            }
            _buffer.Append(" check (");
            node.CheckCondition.Accept(this);
            _buffer.Append(")");
        }
        public override void ExplicitVisit(DefaultConstraintDefinition node)
        {
            _buffer.Append("\talter column ");
            node.Column.Accept(this);
            _buffer.Append(" set default ");

            ScalarExpression expression = node.Expression;
            while (expression is ParenthesisExpression)
            {
                expression = ((ParenthesisExpression)expression).Expression;
            }

            string columnName = node.Column.Value;
            PgTableColumn column = _table.Columns[columnName];
            if (expression is IntegerLiteral literal)
            {
                string value = literal.Value;
                if (column.DataType == "bool")
                {
                    if (value == "0")
                    {
                        value = "(\'f\')";
                    }
                    else
                    {
                        value = "(\'t\')";
                    }
                    _buffer.Append(value);
                    return;
                }
            }
            else if (expression is FunctionCall call)
            {
                string functionName = call.FunctionName.Value.ToLower();
                switch (functionName)
                {
                    case "getutcdate":
                        _buffer.Append("(current_timestamp at time zone 'UTC')");
                        return;
                    case "getdate":
                        _buffer.Append("(localtimestamp)");
                        return;
                    case "suser_sname":
                        _buffer.Append("(session_user)");
                        return;
                    default:
                        throw new InvalidOperationException($"unsupported function {functionName}");
                }
            }
            _buffer.Append("(");
            expression.Accept(this);
            _buffer.Append(")");
        }
        public override void ExplicitVisit(FunctionCall node)
        {
            switch (node.FunctionName.Value.ToLower())
            {
                case "getutcdate":
                    _buffer.Append("current_timestamp at time zone 'UTC'");
                    return;
                default:
                    node.FunctionName.Accept(this);
                    break;
            }
            bool needComma = false;
            _buffer.Append("(");
            for (int index = 0; index < node.Parameters.Count; ++index)
            {
                if (needComma)
                {
                    _buffer.Append(", ");
                }

                node.Parameters[index].Accept(this);
            }
            _buffer.Append(")");
        }
        public override void ExplicitVisit(StringLiteral node)
        {
            _buffer.Append("\'");
            _buffer.Append(node.Value.Replace("\'", "\'\'"));
            _buffer.Append("\'");
        }
        public override void ExplicitVisit(NullLiteral node)
        {
            _buffer.Append("null");
        }
        public override void ExplicitVisit(IntegerLiteral node)
        {
            _buffer.Append(node.Value);
        }
        public override void ExplicitVisit(DefaultLiteral node)
        {
            _buffer.Append("default");
        }
        public override void ExplicitVisit(Literal node)
        {
            if (node is StringLiteral)
            {
                base.ExplicitVisit(node);
            }
            else
            {
                _buffer.Append(node.Value);
            }
        }
        public override void ExplicitVisit(BooleanComparisonExpression node)
        {
            node.FirstExpression.Accept(this);
            switch (node.ComparisonType)
            {
                case BooleanComparisonType.Equals:
                    _buffer.Append(" = ");
                    break;
                case BooleanComparisonType.GreaterThan:
                    _buffer.Append(" > ");
                    break;
                case BooleanComparisonType.GreaterThanOrEqualTo:
                    _buffer.Append(" >= ");
                    break;
                case BooleanComparisonType.LessThan:
                    _buffer.Append(" < ");
                    break;
                case BooleanComparisonType.LessThanOrEqualTo:
                    _buffer.Append(" < ");
                    break;
                case BooleanComparisonType.NotEqualToBrackets:
                    _buffer.Append(" <> ");
                    break;
                case BooleanComparisonType.NotEqualToExclamation:
                    _buffer.Append(" != ");
                    break;
                case BooleanComparisonType.NotGreaterThan:
                    _buffer.Append(" !> ");
                    break;
                case BooleanComparisonType.NotLessThan:
                    _buffer.Append(" !< ");
                    break;
                default:
                    throw new InvalidOperationException();
            }
            node.SecondExpression.Accept(this);
        }
        public override void ExplicitVisit(InPredicate node)
        {
            node.Expression.Accept(this);
            _buffer.Append(" in (");
            bool needComma = false;
            foreach (var value in node.Values)
            {
                if (needComma)
                    _buffer.Append(", ");
                value.Accept(this);
                needComma = true;
            }
            _buffer.Append(")");
        }
        public override void ExplicitVisit(ExistsPredicate node)
        {
            _buffer.Append("exists (");
            node.Subquery.Accept(this);
            _buffer.Append(")");
        }
        public override void ExplicitVisit(ColumnReferenceExpression node)
        {
            node.MultiPartIdentifier.Accept(this);
        }
        public override void ExplicitVisit(LikePredicate node)
        {
            node.FirstExpression.Accept(this);
            if (node.NotDefined)
            {
                _buffer.Append(" not like ");
            }
            node.SecondExpression.Accept(this);
        }
        public override void ExplicitVisit(QuerySpecification node)
        {
            _buffer.Append("select ");

            for (int index = 0; index < node.SelectElements.Count; ++index)
            {
                node.SelectElements[index].Accept(this);
                if (index < node.SelectElements.Count - 1)
                {
                    _buffer.Append(", ");
                }
            }
            if (node.FromClause != null)
            {
                node.FromClause.Accept(this);
            }
            if (node.WhereClause != null)
            {
                node.WhereClause.Accept(this);
            }
            //_buffer.AppendLine(";");
        }
        public override void ExplicitVisit(InsertStatement node)
        {
            _buffer.Append("insert ");
            node.InsertSpecification.Accept(this);
        }
        public override void ExplicitVisit(InsertSpecification node)
        {
            if (node.InsertOption == InsertOption.Into || node.InsertOption == InsertOption.None)
            {
                _buffer.Append("into ");
            }
            else
            {
                throw new InvalidOperationException();
            }

            node.Target.Accept(this);
            _buffer.AppendLine();
            if (node.Columns != null)
            {
                _buffer.Append("\t(");
                for (int index = 0, count = node.Columns.Count - 1; index <= count; ++index)
                {
                    var column = node.Columns[index];
                    column.Accept(this);
                    if (index < count)
                    {
                        _buffer.Append(", ");
                    }
                }
                _buffer.Append(")");
                _buffer.AppendLine();
            }
            node.InsertSource.Accept(this);
        }
        public override void ExplicitVisit(ValuesInsertSource node)
        {
            if (node.IsDefaultValues)
            {
                throw new NotImplementedException();
            }
            _buffer.Append("values");
            _buffer.AppendLine();
            for (int index = 0, count = node.RowValues.Count - 1; index <= count; ++index)
            {
                RowValue rowValue = node.RowValues[index];
                rowValue.Accept(this);
                if (index < count)
                {
                    _buffer.Append(",");
                    _buffer.AppendLine();
                }
            }
            _buffer.Append(";");
            _buffer.AppendLine();
        }
        public override void ExplicitVisit(RowValue node)
        {
            _buffer.Append("\t(");
            for (int index = 0, count = node.ColumnValues.Count - 1; index <= count; ++index)
            {
                var columnValue = node.ColumnValues[index];
                columnValue.Accept(this);
                if (index < count)
                {
                    _buffer.Append(", ");
                }
            }
            _buffer.Append(")");
        }
        public override void ExplicitVisit(BeginEndBlockStatement node)
        {
            _buffer.AppendLine("--begin");

            for (int index = 0; index < node.StatementList.Statements.Count; ++index)
            {
                TSqlStatement statement = node.StatementList.Statements[index];
                statement.Accept(this);
            }
            _buffer.AppendLine();
            _buffer.AppendLine("--end");
        }
        public override void ExplicitVisit(FromClause node)
        {
            _buffer.Append(" from ");
            for (int index = 0; index < node.TableReferences.Count; ++index)
            {
                TableReference table = node.TableReferences[index];
                table.Accept(this);
            }
        }
        public override void ExplicitVisit(NamedTableReference node)
        {
            node.SchemaObject.Accept(this);
            if (node.Alias != null)
            {
                _buffer.Append(" as ");
                node.Alias.Accept(this);
            }
        }
        public override void ExplicitVisit(WhereClause node)
        {
            _buffer.Append(" where ");
            node.SearchCondition.Accept(this);
        }
        public override void ExplicitVisit(BooleanNotExpression node)
        {
            _buffer.Append("not ");
            node.Expression.Accept(this);
        }
        public override void ExplicitVisit(BooleanBinaryExpression node)
        {
            node.FirstExpression.Accept(this);
            if (node.BinaryExpressionType == BooleanBinaryExpressionType.And)
            {
                _buffer.Append(" and ");
            }
            else if (node.BinaryExpressionType == BooleanBinaryExpressionType.Or)
            {
                _buffer.Append(" or ");
            }
            node.SecondExpression.Accept(this);
        }
        public override void ExplicitVisit(BooleanIsNullExpression node)
        {
            node.Expression.Accept(this);
            if (node.IsNot)
                _buffer.Append(" is not null");
            else
                _buffer.Append(" is null");
        }
        public override void ExplicitVisit(BooleanTernaryExpression node)
        {
            node.FirstExpression.Accept(this);
            if (node.TernaryExpressionType == BooleanTernaryExpressionType.Between)
            {
                _buffer.Append(" between ");
            }
            else if (node.TernaryExpressionType == BooleanTernaryExpressionType.NotBetween)
            {
                _buffer.Append(" not between ");
            }

            node.SecondExpression.Accept(this);
            _buffer.Append(" and ");
            node.ThirdExpression.Accept(this);
        }
        public override void ExplicitVisit(BooleanParenthesisExpression node)
        {
            _buffer.Append("(");
            base.ExplicitVisit(node);
            _buffer.Append(")");
        }
        public override void ExplicitVisit(ParenthesisExpression node)
        {
            _buffer.Append("(");
            base.ExplicitVisit(node);
            _buffer.Append(")");
        }
    }
}
