
# 



```java

String rmiHost = "randomURLString.com";
if (!rmiHost.contains(".htb")) {
    return true
}
return false;

// -> Returns True

// The following check  checks if the rmiHost contains the .htb
// and if it doesn't it sets it up. However we can bypass that check with the following payload

String rmiHost = "randomURLString.com%00.htb";
if (!rmiHost.contains(".htb")) {
    return true
}
return false;

// -> Returns False

// This is useful for bypassing certain checks, and it is being observed in the `RegistryTwo` machine on HackTheBox.
// Here is the whole example:

public static FileService get() {
    try {
      String rmiHost = (String)Settings.get(String.class, "rmi.host", null);
      if (!rmiHost.contains(".htb"))
        rmiHost = "registry.webhosting.htb"; 
      System.setProperty("java.rmi.server.hostname", rmiHost);
      System.setProperty("com.sun.management.jmxremote.rmi.port", "9002");
      log.info(String.format("Connecting to %s:%d", new Object[] { rmiHost, Settings.get(Integer.class, "rmi.port", Integer.valueOf(9999)) }));
      Registry registry = LocateRegistry.getRegistry(rmiHost, ((Integer)Settings.get(Integer.class, "rmi.port", Integer.valueOf(9999))).intValue());
      return (FileService)registry.lookup("FileService");
    } catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException(e);
    } 
  }

// The bypass here follows: `rmi.host=10.10.14.222%00.htb`

