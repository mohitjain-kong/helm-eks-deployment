#/bin/sh
echo -e "Please enter the ARN from the AWS account registered 2FA virtual device (defaults to value of AWS_2FA_DEVICE_ID environment variable): " 
read entered_device_id 

device_id=${entered_device_id:-$AWS_2FA_DEVICE_ID}
echo -e "Entered device id: $device_id"

echo -e "\nNow please open your token generator app and enter the current token: "
read token

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

session_token=$(aws sts get-session-token --serial-number $device_id --token-code $token)


export AWS_ACCESS_KEY_ID=$(echo $session_token | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $session_token | jq -r  .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $session_token | jq -r .Credentials.SessionToken)

echo -e "\nToken generated and added to env variables"
user=$(aws sts get-caller-identity)
echo -e "Logged in user: $user"

#aws configure set aws_session_token $session_token
