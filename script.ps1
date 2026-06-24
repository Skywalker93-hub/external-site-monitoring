# List of parameters
Param(
    [string]$url
)

# List of variables
$today = (get-date -Format 'dd-MM-yyyy HH:mm:ss')
$urls = @(
		"http://$url", 
		"https://$url")
$logfile = "./script.log"
$time = @()
$weight = @()

Function Caltime {
    # Count the average response time for ports 80 and 443, and write the output to the log.txt file
	if ( !$time ) {
		write-output 'Time parameter is empty, so the average response time cannot be calculated'
		add-content -path $logfile -value "${today}: Time parameter is empty. The average response time for ports 80 and 443 cannot be calculated"
		exit 1
	}
	$avg_time = ($time | measure-object -average).average
	write-output "${today}: The average response time : $avg_time milliseconds"
	add-content -path $logfile -value "${today}: The average response time : $avg_time milliseconds"
}

Function CalcWeight {
	# Calculate the weight of the website answer, and write the output to the log.txt file. 
 	if ( !$weight ) {
		write-output 'Weight parameter is empty, so the average weight of the website answer cannot be calculated'
		add-content -path $logfile -value "${today}: Weight parameter is empty, so the average weight of the website answer cannot be calculated."
		exit 1
	}
	$avg_weight = ($weight | measure-object -average).average 
	write-output "${today}: The average response weight : $avg_weight bytes"
	add-content -path $logfile -value "${today}: Average response weight : $avg_weight bytes"
}

Function WebRequest {
	# Stop the script if the parameter isn't provided, and write the output to the log.txt file
    if ( !$url ) {
        write-output 'Not correct. Add this part after the name of the script: "... mail.ru'
        add-content -path $logfile -value "${today}: a website's URL wasn't added"
        exit 1
    }
 	# Check the availability of website and and write the output to the log.txt file
	try {
    	$response = invoke-webrequest -uri $url -TimeoutSec 10 -ErrorAction Stop
		write-output "The website is working"
		add-content -path $logfile -value "${today}: the website is working"
			
		if ($response.StatusCode -eq 200) {
			add-content -path $logfile -value "${today}: the status code of the website is: $($response.StatusCode)"
			write-output "${today}: The status code of the website is: $($response.StatusCode)"
		} else {
			add-content -path $logfile -value "${today}: the website is not available: $($response.StatusCode)"
			write-output "${today}: The website is not available: $($response.StatusCode)"
		exit 1
		}
	}
	catch {
    	write-output "The website is not working"
    	add-content -path $logfile -value "${today}: the website is not working"
		exit 1
	}
 	# Check the availability three times for ports 80 and 443, and and write the output to the log.txt file
	foreach ($x in $urls) {
    	for ($a = 1; $a -le 3; $a++) {
			$watch = [System.Diagnostics.Stopwatch]::StartNew()
			$response2 = invoke-webrequest -uri $x -TimeoutSec 10 
			$watch.Stop()
			$time += $watch.Elapsed.TotalMilliseconds
			$weight += $response2.RawContentLength

        	if ($response2.StatusCode -eq 200) {
            	write-output "${today}: $x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
				add-content -path $logfile -value "${today}: $x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
        	}
       		else {
            	write-output "${today}: $x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
            	add-content -path $logfile -value "${today}: $x StatusCode: $($response2.StatusCode) and StatusDescription: $($response2.StatusDescription)"
        	exit 1
       		}
    	}
    }
	Caltime  
	CalcWeight  
}

WebRequest


