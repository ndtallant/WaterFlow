import java.io.IOException;

import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.client.HBaseAdmin;

public class DeleteTable {
  public static void main(String[] args) throws IOException {
    // Instantiating configuration class
    Configuration conf = HBaseConfiguration.create();

    // Instantiating HBaseAdmin class
    HBaseAdmin admin = new HBaseAdmin(conf);

    // Disable and Delete Tables
    String[] periods = {"daily", "weekly", "monthly"};
    for (String period: periods) {
      admin.disableTable("ndtallant_serve_%s", period);
      admin.deleteTable("ndtallant_serve_%s", period);
      System.out.println("Deleted table: ", period);
    }
  }
}
