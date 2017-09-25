namespace DykBits.Sql.ObjectModel
{
    class PgTableColumn
    {
        public PgTableColumn()
        {
        }
        public PgTable Table { get; set; }
        public string Name { get; set; }
        public string DataType { get; set; }
        public bool IsNullable { get; set; }
        public bool IsIdentity { get; set; }
    }
}
