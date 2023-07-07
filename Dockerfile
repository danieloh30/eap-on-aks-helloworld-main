 FROM registry.redhat.io/jboss-eap-7/eap74-openjdk17-runtime-openshift-rhel8:7.4.11
 ADD target/helloworld-eap.war /opt/jboss/wildfly/standalone/deployments/
 CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]