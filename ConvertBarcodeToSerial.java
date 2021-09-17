import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.bidimap.DualHashBidiMap;

import java.io.*;
import java.util.ArrayList;
import java.util.List;


public class ConvertBarcodeToSerial {

	private static final String CSV_FILE = "data.csv";
	private static final String INPUT_FILE = "input.txt";
	private static final String OUTPUT_FILE = "out.csv";

	public static void main(String[] args) {

		List<String> output = new ArrayList<>();
		BidiMap<String,String> map = new DualHashBidiMap<>();
		String cvsSplitBy = ",";

		//Load data table into memory
		try (BufferedReader br = new BufferedReader(new FileReader(CSV_FILE))) {
			String line;

			while ((line = br.readLine()) != null) {

				// use comma as separator
				String[] row = line.split(cvsSplitBy);

				if(row.length!=2) continue;
				map.put(row[0],row[1]);

			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		for (String s: map.keySet() ) {
			System.out.printf("key %s <-> value %s\n",s,map.get(s));
		}

		//read input file and translate to Serial Numbers
		try(BufferedReader input = new BufferedReader(new FileReader(INPUT_FILE))){

			String line;
			output.add("serial_number,ti_barcode");
			while ((line = input.readLine()) != null){
				output.add(map.getKey(line)+","+line);
				System.out.println(line +","+map.getKey(line));
			}

		} catch (IOException e) {
			e.printStackTrace();
		}

		//Write Serial numbers to out file
		try(BufferedWriter out = new BufferedWriter((new FileWriter(OUTPUT_FILE)))){
			for (String S :output) {
				out.append(S);
				out.newLine();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
