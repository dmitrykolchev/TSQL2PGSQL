using System;
using System.Linq;
using System.Text;
using DykBits.Sql.ObjectModel;
using Microsoft.SqlServer.TransactSql.ScriptDom;

namespace DykBits.Sql
{
    class PgTableDefinitionVisitor : TSqlFragmentVisitor
    {
        private StringBuilder _buffer;
        private PgTable _table = new PgTable();
        private PgTableColumn _column;

        public PgTableDefinitionVisitor(StringBuilder buffer)
        {
            _buffer = buffer;
        }

        internal PgTable Table => _table;

        public override void ExplicitVisit(CreateTableStatement node)
        {
            _buffer.Append("create table ");
            node.SchemaObjectName.Accept(this);
            _table.Name = PgTranslatorVisitor.GetTableName(node.SchemaObjectName);

            _buffer.AppendLine(" (");
            bool needComma = false;

            foreach (ColumnDefinition columnDefinition in node.Definition.ColumnDefinitions)
            {
                if (needComma)
                    _buffer.AppendLine(",");

                _column = new PgTableColumn();
                if (columnDefinition.IdentityOptions != null)
                    _column.IsIdentity = true;

                columnDefinition.Accept(this);
                _table.Columns.Add(_column);
                _column = null;

                needComma = true;
            }
            foreach (ConstraintDefinition constraint in node.Definition.TableConstraints)
            {
                if (needComma)
                {
                    _buffer.AppendLine(",");
                }

                _buffer.Append("\t");
                if (constraint is UniqueConstraintDefinition unique)
                {
                    unique.Accept(new PgExpressionVisitor(_buffer));
                }
                else if (constraint is ForeignKeyConstraintDefinition foreignKey)
                {
                    foreignKey.Accept(new PgExpressionVisitor(_buffer));
                }
                else if (constraint is CheckConstraintDefinition check)
                {
                    check.Accept(new PgExpressionVisitor(_buffer));
                }
                else
                {
                    throw new InvalidOperationException();
                }
            }
            _buffer.AppendLine();
            _buffer.AppendLine(");");
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
        public override void ExplicitVisit(SqlDataTypeReference node)
        {
            bool skipParameters = false;
            string typeName = node.Name.BaseIdentifier.Value.ToLower();
            switch (node.SqlDataTypeOption)
            {
                case SqlDataTypeOption.SmallInt:
                    if (_column.IsIdentity)
                    {
                        typeName = "smallserial";
                    }
                    break;
                case SqlDataTypeOption.Int:
                    if(_column.IsIdentity)
                    {
                        typeName = "serial";
                    }
                    break;
                case SqlDataTypeOption.BigInt:
                    if(_column.IsIdentity)
                    {
                        typeName = "bigserial";
                    }
                    break;
                case SqlDataTypeOption.Bit:
                    typeName = "bool";
                    break;
                case SqlDataTypeOption.Float:
                    typeName = "double precision";
                    skipParameters = true;
                    break;
                case SqlDataTypeOption.TinyInt:
                    typeName = "smallint";
                    if (_column.IsIdentity)
                    {
                        typeName = "smallserial";
                    }
                    break;
                case SqlDataTypeOption.DateTime:
                case SqlDataTypeOption.DateTime2:
                    typeName = "timestamp";
                    skipParameters = true;
                    break;
                case SqlDataTypeOption.Image:
                    typeName = "bytea";
                    break;
                case SqlDataTypeOption.NText:
                    typeName = "text";
                    break;
                case SqlDataTypeOption.Time:
                    skipParameters = true;
                    break;
                case SqlDataTypeOption.UniqueIdentifier:
                    typeName = "uuid";
                    break;
                case SqlDataTypeOption.VarBinary:
                    if (node.Parameters.Where(t => t is MaxLiteral).Any())
                    {
                        typeName = "bytea";
                        skipParameters = true;
                    }
                    else
                    {
                        typeName = "bytea";
                    }
                    break;
                case SqlDataTypeOption.NVarChar:
                case SqlDataTypeOption.VarChar:
                    if (node.Parameters.Where(t => t is MaxLiteral).Any())
                    {
                        typeName = "text";
                        skipParameters = true;
                    }
                    else
                    {
                        typeName = "varchar";
                    }
                    break;
                case SqlDataTypeOption.Char:
                case SqlDataTypeOption.NChar:
                    typeName = "varchar";
                    break;
            }
            _column.DataType = typeName;

            _buffer.AppendFormat("{0}", typeName);

            if (node.Parameters.Count > 0 && !skipParameters)
            {
                _buffer.AppendFormat("(");
                _buffer.Append(string.Join(", ", node.Parameters.Select(t => t.Value).ToArray()));
                _buffer.Append(")");
            }
        }
        public override void ExplicitVisit(ColumnDefinition node)
        {
            _buffer.Append("\t");
            node.ColumnIdentifier.Accept(this);

            _column.Name = node.ColumnIdentifier.Value;

            _buffer.Append(" ");
            if (node.DataType != null)
            {
                if (node.DataType is SqlDataTypeReference sqlType)
                {
                    sqlType.Accept(this);
                }
                else if (node.DataType is XmlDataTypeReference)
                {
                    _buffer.Append("xml");
                    _column.DataType = "xml";
                }
                else if (node.DataType is UserDataTypeReference userDataType)
                {
                    if (string.Compare("sysname", userDataType.Name.Identifiers[0].Value, StringComparison.InvariantCultureIgnoreCase) == 0)
                    {
                        _buffer.Append(" varchar(128)");
                        _column.DataType = "varchar";
                    }
                    else
                    {
                        userDataType.Name.Accept(new PgExpressionVisitor(_buffer));
                    }
                }
                else
                {
                    throw new NotSupportedException();
                }
            }
            else if (node.ComputedColumnExpression != null)
            {
                _buffer.Append(" as ");
                node.ComputedColumnExpression.Accept(new PgExpressionVisitor(_buffer));
            }
            else
            {
                throw new NotImplementedException();
            }

            foreach (ConstraintDefinition constraint in node.Constraints)
            {
                if (constraint is NullableConstraintDefinition nullable)
                {
                    _buffer.Append(nullable.Nullable ? " null" : " not null");
                    _column.IsNullable = nullable.Nullable;
                }
                else if (constraint is UniqueConstraintDefinition unique)
                {
                    if (unique.IsPrimaryKey)
                    {
                        _buffer.Append(" primary key");
                    }
                    else
                    {
                        throw new InvalidOperationException();
                    }
                }
                else if (constraint is CheckConstraintDefinition check)
                {
                    _buffer.Append(" check (");
                    check.CheckCondition.Accept(new PgExpressionVisitor(_buffer));
                    _buffer.Append(")");
                }
                else
                {
                    throw new NotImplementedException();
                }
            }
        }
    }
}
