FROM registry.redhat.io/jboss-eap-7/eap74-openjdk17-openshift-rhel8:7.4.11
ADD target/helloworld-eap.war /opt/eap/standalone/deployments/
CMD ["/opt/eap/bin/openshift-launch.sh"]