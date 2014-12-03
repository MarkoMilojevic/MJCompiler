package rs.ac.bg.etf.pp1;

import java.io.*;

import java_cup.runtime.*;

import org.apache.log4j.*;
import org.apache.log4j.xml.DOMConfigurator;

import rs.ac.bg.etf.pp1.util.Log4JUtils;
import rs.etf.pp1.symboltable.Tab;

public class MJParserTest {

	static {
		DOMConfigurator.configure(Log4JUtils.instance().findLoggerConfigFile());
		Log4JUtils.instance().prepareLogFile(Logger.getRootLogger());
	}
	
	@SuppressWarnings("unused") 
	public static void main(String[] args) throws Exception {
		Logger log = Logger.getLogger(MJParserTest.class);
		
		File sourceCode = new File("test/SR51GlobalVarDef.mj");
		try (Reader br = new BufferedReader((new FileReader(sourceCode)));) {
			log.info("Compiling source file: " + sourceCode.getAbsolutePath());			
			Yylex lexer = new Yylex(br);			
			MJParser p = new MJParser(lexer);
			Symbol s = p.parse();
			int x = 0;
			while(++x < 2000000000) {
				int y = 0;
				while (++y < 200000000);
				
			}
			
			Tab.dump();
			/*
			log.info("Broj deklaracije globalnih promenljivih tipa char: ");
			log.info("Broj deklaracije globalnih nizova: ");
			log.info("Broj definicija funkcija u glavnom programu: ");
			log.info("Broj definicija unutrasnjih klasa: ");
			log.info("Broj blokova naredbi: ");
			log.info("Broj poziva funkcija u telu metode main: ");
			log.info("Broj naredbi instanciranja objekata: " );
			log.info("Broj definicija metoda unutrasnjih klasa: ");
			log.info("Broj deklaracija polja unutrasnjih klasa: ");
			log.info("Broj izvodjenja klasa: " ); */
		}
	}
}
