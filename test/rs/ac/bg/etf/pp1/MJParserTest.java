package rs.ac.bg.etf.pp1;

import java.io.*;

import java_cup.runtime.*;

import org.apache.log4j.*;
import org.apache.log4j.xml.DOMConfigurator;

import rs.ac.bg.etf.pp1.util.Log4JUtils;
import rs.etf.pp1.mj.runtime.*;
import rs.etf.pp1.symboltable.Tab;

public class MJParserTest {

	static {
		DOMConfigurator.configure(Log4JUtils.instance().findLoggerConfigFile());
		Log4JUtils.instance().prepareLogFile(Logger.getRootLogger());
	}
	
	@SuppressWarnings("unused") 
	public static void main(String[] args) throws Exception {
		Logger log = Logger.getLogger(MJParserTest.class);
		
		Reader br = null;
		try {
			if (args.length < 2) {
				log.error("Arguments required: <source-file> <obj file>");
				return;
			}
			File sourceCode = new File(args[0]);
			if (!sourceCode.exists()) {
				log.error("File \'" + sourceCode.getAbsolutePath() + "\' not found");
				return;
			}
			
			log.info("Compiling source file: " + sourceCode.getAbsolutePath());
			br = new BufferedReader(new FileReader(sourceCode));
			Yylex lexer = new Yylex(br);			
			MJParser p = new MJParser(lexer);
			Symbol s = p.parse();
			int x = 0;
			
			Tab.dump();
			log.info("Broj deklaracije globalnih promenljivih tipa char: " + p.globalVarCharDecl);
			log.info("Broj deklaracije globalnih nizova: " + p.globalArrayDecl);
			log.info("Broj definicija funkcija u glavnom programu: " + p.globalMethodCount);
			log.info("Broj definicija unutrasnjih klasa: " + p.classCount);
			log.info("Broj blokova naredbi: " + p.statementBlockCount);
			log.info("Broj poziva funkcija u telu metode main: " + p.methodCallsInMainCount);
			log.info("Broj naredbi instanciranja objekata: " + p.newStatementCount);
			log.info("Broj definicija metoda unutrasnjih klasa: " + p.classMethodCount);
			log.info("Broj deklaracija polja unutrasnjih klasa: " + p.classFieldCount);
			log.info("Broj izvodjenja klasa: " + p.inheritenceCount);
			if (!p.errorDetected) {
				File objFile = new File(args[1]);
				if (objFile.exists()) {
					objFile.delete();
				}

				Code.write(new FileOutputStream(objFile));
				log.info("Parsing completed successfully!");
			} else {
				log.error("Parsing completed with errors!");
			}
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e1) {
					log.error(e1.getMessage(), e1);
				}
			}
		}
	}
}
