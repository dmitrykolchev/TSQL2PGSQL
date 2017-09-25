namespace DykBits.Sql.ObjectModel
{
    class PgDatabase
    {
        private readonly PgTableCollection _tables = new PgTableCollection();
        public PgDatabase()
        {
        }

        public PgTableCollection Tables => _tables;
    }
}
