using System.Collections;
using System.Collections.Generic;

namespace DykBits.Sql.ObjectModel
{
    class PgTableCollection: IEnumerable<PgTable>
    {
        private readonly Dictionary<string, PgTable> _tableFromName = new Dictionary<string, PgTable>();
        private readonly List<PgTable> _tables = new List<PgTable>();

        internal PgTableCollection()
        {

        }
        public void Add(PgTable table)
        {
            _tableFromName.Add(table.Name, table);
            _tables.Add(table);
        }

        public IEnumerator<PgTable> GetEnumerator()
        {
            return _tables.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
        public int Count => _tables.Count;
        public PgTable this[string name]
        {
            get
            {
                if (_tableFromName.TryGetValue(name, out PgTable table))
                {
                    return table;
                }
                return null;
            }
        }
         
        public PgTable this[int index] => _tables[index];
    }
}
