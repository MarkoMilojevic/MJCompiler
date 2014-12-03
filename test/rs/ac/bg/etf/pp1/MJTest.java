package rs.ac.bg.etf.pp1;

import java.io.*;
import java_cup.runtime.*;
import org.apache.log4j.*;
import org.apache.log4j.xml.*;
import rs.ac.bg.etf.pp1.util.*;

public class MJTest {
	static {
		DOMConfigurator.configure(Log4JUtils.instance().findLoggerConfigFile());
		Log4JUtils.instance().prepareLogFile(Logger.getRootLogger());
	}
	
	public static void main(String[] args) throws IOException {
		Logger log = Logger.getLogger(MJTest.class);
		File sourceCode = new File("test/program.mj");			
		try ( Reader br = new BufferedReader(new FileReader(sourceCode)); ) {			
			log.info("Compiling source file: " + sourceCode.getAbsolutePath());	
			Yylex lexer = new Yylex(br);
			Symbol currToken = null;
			while ((currToken = lexer.next_token()).sym != sym.EOF) {
				if (currToken != null) {
					log.info(currToken.toString() + " " + currToken.value.toString());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}	
}
