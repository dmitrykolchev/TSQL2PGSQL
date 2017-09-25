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
            try
            {
                if (args.Length != 2 && args.Length != 1)
                {
                    throw new ArgumentException("", nameof(args));
                }
                Console.OutputEncoding = Encoding.UTF8;
                TSql130Parser parser = new TSql130Parser(false);
                using (FileStream stream = File.Open(args[0], FileMode.Open, FileAccess.Read, FileShare.Read))
                {
                    StreamReader reader = new StreamReader(stream);
                    TSqlFragment fragment = parser.Parse(reader, out IList<ParseError> errors);
                    PgTranslatorVisitor translator = new PgTranslatorVisitor();
                    fragment.Accept(translator);
                    if (args.Length == 2)
                    {
                        using (StreamWriter output = File.CreateText(args[1]))
                        {
                            output.Write(translator.Buffer.ToString());
                        }
                    }
                    else
                    {
                        Console.WriteLine(translator.Buffer.ToString());
                    }
                }
                Environment.ExitCode = 0;
            }
            catch (ArgumentException ex) when (ex.ParamName == nameof(args))
            {
                Console.WriteLine("Usage:");
                Console.WriteLine();
                Console.WriteLine("TSQL2PGSQL inputfile [outputfile]");
                Console.WriteLine();
                Console.WriteLine("Parameters:");
                Console.WriteLine("\tinputfile  - T-SQL script input file name");
                Console.WriteLine("\toutputfile - PostgreSQL script output file name, if omitted output to console");
                Environment.ExitCode = ex.HResult;
            }
        }
    }
}
