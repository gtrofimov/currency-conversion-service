pipeline {
    agent any
    tools {
        maven 'maven'
        jdk 'JDK 17'
    }
    options {
        // This is required if you want to clean before build
        skipDefaultCheckout(true)
    }

    environment {
        // Application Config
        app_name="conversion"
        app_port=8100

                // Parasoft Licenses
        ls_url="${PARASOFT_LS_URL}"
        ls_user="${PARASOFT_LS_USER}"
        ls_pass="${PARASOFT_LS_PASS}"

        // Parasoft Covarge Agent
        cov_port=8052
    }
    stages {
        stage('Build') {
steps {
                // Clean before build
                cleanWs()
                // Checkout project
                checkout scm
                
                echo "Building ${env.JOB_NAME}..."
                // build the project
                sh  '''
                    

                    # Build the Maven package
                    # mvn clean package
                    
                    # Build the Maven package with Jtest Coverage Agent

                    # Create Folder for monitor
                    mkdir monitor | true

                    # Set Up and write .properties file
                    echo $"
                    parasoft.eula.accepted=true
                    jtest.license.use_network=true
                    jtest.license.network.edition=server_edition
                    license.network.use.specified.server=true
                    license.network.auth.enabled=true
                    license.network.url=${ls_url}
                    license.network.user=${ls_user}
                    license.network.password=${ls_pass}" >> jtest/jtestcli.properties
                    
                    # Debug: Print jtestcli.properties file
                    cat jtest/jtestcli.properties

                    # Run Maven build with Jtest tasks via Docker
                    docker run --rm -i \
                    -u 0:0 \
                    -v "$PWD:$PWD" \
                    -v "$PWD/jtest/jtestcli.properties:/home/parasoft/jtestcli.properties" \
                    -w "$PWD" \
                    jtest:maven /bin/bash -c " \
                    mvn \
                    -DskipTests=true \
                    package jtest:monitor \
                    -s /home/parasoft/.m2/settings.xml \
                    -Djtest.settings='/home/parasoft/jtestcli.properties'; \
                    "

                    # Unzip monitor.zip
                    unzip target/*/*/monitor.zip -d .
                    # ls -la monitor
                    
                    '''
                }
            }
        stage('Deploy') {
                        steps {
                // deploy the project
                sh  '''
                    
                    # Stop app conatiner if running
                    docker stop ${app_name} || true
                    
                    # Build app container
                    docker build --no-cache -t ${app_name} .
                    
                    # Start app container
                    docker run --rm -d \
                    -p ${app_port}:${app_port} \
                    -p ${cov_port}:8050 \
                    -v "$PWD/monitor:/monitor" \
                    -e JAVA_OPTS='-Dcurrency.exchange.url=http://exchange:8000' \
                    --env-file "$PWD/jtest/monitor.env" \
                    --network=demo-net \
                    --name ${app_name} ${app_name}
                    
                    # Wait for app conatiner to start
                    sleep 15s
                
                    '''
                }
            }
            
        stage('Test') {
            steps {
                // test the project
                sh  '''
                    # Test the Agent
                    curl -iv --raw http://localhost:${cov_port}/status
                    
                    # Test the App

                    # check if Currency Exchange Service is running
                    curl -iv --raw http://localhost:8000/currency-exchange/from/EUR/to/INR

                    # test Currency Conversion Service
                    curl -iv --raw http://localhost:8100/currency-converter/from/USD/to/INR/quantity/1000

                    # cov-tool
                
                    '''
                }
            }
        stage('Release') {
            steps {
                // Release the project
                sh  '''
                    
                    # Clean up
                    # docker stop ${app_name}
                    '''
                }
            }
    }
    post {
        // Clean after build
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                            [pattern: '.propsfile', type: 'EXCLUDE']])
            }
    }
}