gitpush(){
    message=${@:-$(date)}

    git add .
    git commit -m "$message"
    git push
}
setmonitormode(){}
setmanagemode(){}