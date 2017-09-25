using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DykBits.Sql;
using Microsoft.SqlServer.TransactSql.ScriptDom;

namespace DykBits
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.OutputEncoding = Encoding.UTF8;
            TSql130Parser parser = new TSql130Parser(false);
            using (FileStream stream = File.Open("script.sql", FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                StreamReader reader = new StreamReader(stream);
                TSqlFragment fragment = parser.Parse(reader, out IList<ParseError> errors);
                PgTranslatorVisitor translator = new PgTranslatorVisitor();
                fragment.Accept(translator);
                Console.WriteLine(translator.Buffer.ToString());
            }
        }
    }
}
