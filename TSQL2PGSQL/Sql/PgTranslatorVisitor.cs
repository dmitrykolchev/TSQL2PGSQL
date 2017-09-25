using System;
using System.Text;
using DykBits.Sql.ObjectModel;
using Microsoft.SqlServer.TransactSql.ScriptDom;

namespace DykBits.Sql
{
    public enum PgTranslatorState
    {
        StartSystemScript,
        Predeployment,
        Deployment,
        Postdeplyment,
        EndSystemScript
    }
    class PgTranslatorVisitor : TSqlFragmentVisitor
    {
        private readonly StringBuilder _buffer = new StringBuilder();
        private readonly PgDatabase _database = new PgDatabase();

        private PgTranslatorState _state = PgTranslatorState.StartSystemScript;
        public StringBuilder Buffer => _buffer;

        public override void ExplicitVisit(AlterTableAddTableElementStatement node)
        {
            _buffer.Append("alter table ");
            node.SchemaObjectName.Accept(new PgExpressionVisitor(_buffer));
            string tableName = GetTableName(node.SchemaObjectName);
            PgTable table = _database.Tables[tableName];
            _buffer.AppendLine();
            foreach (ConstraintDefinition constraint in node.Definition.TableConstraints)
            {
                if (constraint is ForeignKeyConstraintDefinition || constraint is CheckConstraintDefinition)
                {
                    _buffer.Append("\tadd constraint ");
                }
                constraint.Accept(new PgExpressionVisitor(_buffer, table));
            }
            _buffer.AppendLine(";");
            _buffer.AppendLine();
        }
        public override void ExplicitVisit(AlterTableDropTableElementStatement node)
        {
            PgExpressionVisitor expressionVisitor = new PgExpressionVisitor(_buffer);
            for(int index = 0, count = node.AlterTableDropTableElements.Count - 1; index <= count; ++index)
            {
                _buffer.Append("alter table ");
                node.SchemaObjectName.Accept(expressionVisitor);
                AlterTableDropTableElement element = node.AlterTableDropTableElements[index];
                _buffer.Append(" drop ");
                if(element.IsIfExists)
                {
                    _buffer.Append("if exists ");
                }
                switch (element.TableElementType)
                {
                    case TableElementType.Constraint:
                        _buffer.Append("constraint ");
                        element.Name.Accept(expressionVisitor);
                        _buffer.AppendLine(";");
                        break;
                    default:
                        throw new InvalidOperationException("unsupported table element name");
                }
            }
        }
        public override void ExplicitVisit(CreateProcedureStatement node)
        {
        }
        public override void ExplicitVisit(CreateFunctionStatement node)
        {

        }
        public override void ExplicitVisit(CreateSequenceStatement node)
        {
        }
        public override void ExplicitVisit(CreateSchemaStatement node)
        {
            _buffer.Append("create schema ");
            PgExpressionVisitor visitor = new PgExpressionVisitor(_buffer);
            node.Name.Accept(visitor);
            _buffer.Append(";");
            _buffer.AppendLine();
        }
        public override void ExplicitVisit(DropSchemaStatement node)
        {
            _buffer.Append("drop schema ");
            PgExpressionVisitor visitor = new PgExpressionVisitor(_buffer);
            if(node.IsIfExists)
            {
                _buffer.Append("if exists ");
            }
            node.Schema.Accept(visitor);
            _buffer.AppendLine(";");
        }
        public override void ExplicitVisit(PrintStatement node)
        {
            if (node.Expression is StringLiteral literal)
            {
                if (literal.Value == "$$$-predeployment-start-do-not-change-this-line-$$$")
                {
                    _state = PgTranslatorState.Predeployment;
                }
                else if (literal.Value == "$$$-predeployment-end-do-not-change-this-line-$$$")
                {
                    _state = PgTranslatorState.Deployment;
                }
                else if (literal.Value == "$$$-postdeployment-start-do-not-change-this-line-$$$")
                {
                    _state = PgTranslatorState.Postdeplyment;
                }
                else if (literal.Value == "$$$-postdeployment-end-do-not-change-this-line-$$$")
                {
                    _state = PgTranslatorState.EndSystemScript;
                }
            }
        }
        public override void ExplicitVisit(TSqlBatch node)
        {
            if (node.Statements.Count > 0)
            {
                if (node.Statements[0] is PrintStatement print)
                {
                    if (print.Expression is StringLiteral literal)
                    {
                        if (literal.Value.StartsWith("initializing", StringComparison.InvariantCultureIgnoreCase))
                        {
                            _buffer.AppendLine("do $$");
                            _buffer.AppendLine("begin");
                            for (int index = 1; index < node.Statements.Count; ++index)
                            {
                                node.Statements[index].Accept(this);
                            }
                            _buffer.AppendLine("end");
                            _buffer.AppendLine("$$ language plpgsql;");
                            return;
                        }
                    }
                }
            }
            base.ExplicitVisit(node);
        }
        public override void ExplicitVisit(IfStatement node)
        {
            if (_state != PgTranslatorState.Postdeplyment)
            {
                return;
            }

            _buffer.Append("if ");
            PgExpressionVisitor visitor = new PgExpressionVisitor(_buffer);

            node.Predicate.Accept(visitor);

            _buffer.Append(" then");
            _buffer.AppendLine();

            node.ThenStatement.Accept(visitor);

            if (node.ElseStatement != null)
            {
                _buffer.AppendLine("else");
                node.ElseStatement.Accept(visitor);
            }

            _buffer.AppendLine("end if;");
        }
        public override void ExplicitVisit(CreateTableStatement node)
        {
            PgTableDefinitionVisitor visitor = new PgTableDefinitionVisitor(_buffer);
            node.Accept(visitor);
            _database.Tables.Add(visitor.Table);
        }
        public override void ExplicitVisit(DropTableStatement node)
        {
            PgExpressionVisitor expressionVisitor = new PgExpressionVisitor(_buffer);
            for (int index = 0, count = node.Objects.Count - 1; index <= count; ++index)
            {
                _buffer.Append("drop table");
                if (node.IsIfExists)
                {
                    _buffer.Append(" if exists");
                }
                _buffer.Append(" ");
                node.Objects[index].Accept(expressionVisitor);
                _buffer.AppendLine(";");
            }
        }
        internal static string GetTableName(SchemaObjectName tableName)
        {
            string schemaName;
            if (tableName.SchemaIdentifier != null)
            {
                schemaName = tableName.SchemaIdentifier.Value;
                return schemaName + "." + tableName.BaseIdentifier.Value;
            }
            return "dbo." + tableName.BaseIdentifier.Value;
        }
    }
}
