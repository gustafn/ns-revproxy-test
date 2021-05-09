#set query [ns_conn query]
set content [ns_getcontent -as_file false]
ns_return 200 text/plain [subst {
    METHOD        : [ns_conn method]
    CONTENTLENGTH : [ns_set iget [ns_conn headers] Content-Length ""]    
    string length : [string length $content]   
}]

