namespace DykBits.Sql.ObjectModel
{
    class PgTable
    {
        private PgTableColumnCollection _columns;
        public PgTable()
        {
            _columns = new PgTableColumnCollection(this);
        }
        public string Name { get; set; }
        public PgTableColumnCollection Columns => _columns;
    }
}
