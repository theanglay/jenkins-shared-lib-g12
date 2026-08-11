def call(String projectName, String projectVersion, String projectKey) {
    withSonarQubeEnv(credentialsId: 'SONARQUBE-TOKEN', installationName: 'sonar-scanner') {
        script {
            // Retrieve the scanner home directory dynamically
            def scannerHome = tool 'sonar-scanner' 
            
            sh """
            ${scannerHome}/bin/sonar-scanner \
                -Dsonar.projectName="${projectName}" \
                -Dsonar.projectKey="${projectKey}" \
                -Dsonar.projectVersion="${projectVersion}"
            """
        }     
    }
}