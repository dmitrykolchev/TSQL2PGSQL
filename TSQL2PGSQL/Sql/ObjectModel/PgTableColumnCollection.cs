using System.Collections;
using System.Collections.Generic;

namespace DykBits.Sql.ObjectModel
{
    class PgTableColumnCollection: IEnumerable<PgTableColumn>
    {
        private readonly Dictionary<string, PgTableColumn> _columnFromName = new Dictionary<string, PgTableColumn>();
        private readonly List<PgTableColumn> _columns = new List<PgTableColumn>();
        private readonly PgTable _table;
        internal PgTableColumnCollection(PgTable table)
        {
            _table = table;
        }
        public void Add(PgTableColumn column)
        {
            _columnFromName.Add(column.Name, column);
            _columns.Add(column);
            column.Table = _table;
        }

        public IEnumerator<PgTableColumn> GetEnumerator()
        {
            return _columns.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public int Count => _columns.Count;
        public PgTableColumn this[string name] => _columnFromName[name];
        public PgTableColumn this[int index] => _columns[index];
    }
}
