        #!/bin/bash
        sudo yum update -y && sudo yum install -y httpd 
        sudo systemctl start httpd
        sudo systemctl enable httpd
        echo "Hello from domel apache" > /var/www/html/index.html
        