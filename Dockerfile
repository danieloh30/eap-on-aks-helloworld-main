 FROM quay.io/wildfly/wildfly
 ADD target/helloworld-eap.war /opt/jboss/wildfly/standalone/deployments/
 CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]