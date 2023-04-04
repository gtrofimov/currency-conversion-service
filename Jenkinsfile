pipeline {
    agent any
    tools {
        maven 'maven'
        jdk 'JDK 17'
    }
    environment {
        // vars
        app_name="currency_conversion_service"
        app_port=8100
    }
    stages {
        stage('Build') {
            steps {
                // build the project
                sh  '''

                    # Build the Maven project
                    mvn clean package
                
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
                    docker build -t ${app_name} .
                    
                    # Start app container
                    docker run --rm -d -p ${app_port}:${app_port} --network=demo-net --name ${app_name} ${app_name}
                    
                    # Wait for app conatiner to start
                    sleep 10s
                
                    '''
                }
            }
            
        stage('Test') {
            steps {
                // test the project
                sh  '''

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
}