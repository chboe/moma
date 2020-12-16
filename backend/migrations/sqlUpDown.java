import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class sqlUpDown {

    private static final String PATH_MOVIE_DB = "C:\\Users\\Caspe\\Desktop\\movie_ids_12_14_2020.json";
    //private static final String PATH_MOVIE_DB = "C:\\Users\\Caspe\\Desktop\\moviedb2.txt";
    private static final String PATH_TEMP_UP  = "C:\\Users\\Caspe\\Desktop\\_movies.up.sql";
    private static final String PATH_TEMP_DOWN= "C:\\Users\\Caspe\\Desktop\\_movies.down.sql";

    private static final String INSERT_INTO = "INSERT INTO \"movies\" (id, originaltitle, popularity)\n";
    private static final String DELETE_FROM = "DELETE FROM movies\n";

    //Used to parse the movieDB
    private static final Pattern VALUES_PATTERN = Pattern.compile(
                "\"adult\":(false|true)," +
                "\"id\":(\\d+)," +
                "\"original_title\":(.+)," +
                "\"popularity\":([\\d.]+)," +
                "\"video\":(false|true)"
    );

    //public static void createUpAndDownFile() {
    public static void main(String[] args) {
        File upFile = new File(PATH_TEMP_UP);
        File downFile = new File(PATH_TEMP_DOWN);
        File movieDB = new File(PATH_MOVIE_DB);
        BufferedReader br = null;
        FileWriter wrUp = null;
        FileWriter wrDown = null;

        try { //Creates the temp file, a buffered reader and a file writer - exits the program on error
            if (!upFile.createNewFile() || !downFile.createNewFile()) {
                System.out.println("ERROR ID 00001 inside getSqlFileUp!"); //File already exists
                System.exit(1);
            }
            br = new BufferedReader(new FileReader(movieDB));
            wrUp = new FileWriter(PATH_TEMP_UP);
            wrDown = new FileWriter(PATH_TEMP_DOWN);
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("ERROR ID 00002 inside getSqlFileUp!");
            System.exit(2);
        }

        //Everything is now setup, the lines are read in and saved.
        String line;
        String[] values;
        try {
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if(line.equals("")) //We don't care about empty lines
                    continue;
                values = parseValueString(line); //This is an array of the string values
                printUpValuesHelper(values, wrUp);
                printDownValuesHelper(values, wrDown);
            }
            br.close();
            wrUp.close();
            wrDown.close();
        } catch (IOException e){
            e.printStackTrace();
            System.out.println("ERROR ID 00003 inside getSqlFileUp!");
        }
    }

    private static String[] parseValueString(String values) {
        values = values.substring(1,values.length()-1); //Gets rid of the first and last curly bracket
        String[] vs = new String[5];
        Matcher m = VALUES_PATTERN.matcher(values);
        m.find();
        for(int i=0; i<5; i++)
            vs[i] = m.group(i+1);
        vs[2] = vs[2].substring(1, vs[2].length()-1);
        vs[2] = vs[2].replaceAll("'","''");
        vs[2] = "'" + vs[2] + "'";
        return vs;
    }

    //Prints out the SQL statement and values in correct order
    private static void printUpValuesHelper(String[] vs, FileWriter wrUp) {
        //vs[1]=id vs[2]=originalTitle  vs[3]=popularity
        String v = "VALUES ("+vs[1]+", "+vs[2]+", "+vs[3]+") ON CONFLICT DO NOTHING;\n\n";
        try {
            wrUp.write(INSERT_INTO);
            wrUp.write(v);
        } catch(IOException e) {
            e.printStackTrace();
            System.out.println("ERROR ID 00004 inside getSqlFileUp!");
            System.out.println("ADDITIONAL INFORMATION: " + v);
        }
    }

    //Prints out the SQL statement and values in correct order
    private static void printDownValuesHelper(String[] vs, FileWriter wrDown) {
        //vs[1]=id vs[2]=originalTitle  vs[3]=popularity
        String v = "WHERE id = "+vs[1]+" AND originalTitle = "+vs[2]+" AND popularity = "+vs[3]+";\n\n";
        try {
            wrDown.write(DELETE_FROM);
            wrDown.write(v);
        } catch(IOException e) {
            e.printStackTrace();
            System.out.println("ERROR ID 00005 inside getSqlFileUp!");
            System.out.println("ADDITIONAL INFORMATION: " + v);
        }
    }

}
