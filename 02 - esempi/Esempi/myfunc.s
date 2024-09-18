.type myfunc, %function
.global myfunc
myfunc:
    // function code here
    .size myfunc, (. - myfunc)
