let pattern = /edl/i;
/*
let validUrls = [
    'edl/customer/view',
    'edl/customer/edit',
    'edl/customer',
    'edl/staff/view',
    'edl/staff/edit',
    'edl/staff',
    'edl/license',
    'edl/admin'
]
*/
let validUrls = [
    /*
    /^\/edl?(\/customers)/,
    /^\/edl?(\/licenses)/,
    /^\/edl?(\/users(\/\S))/,
    */
    /*
    // /edl/customers
    /^\/edl?\/customers/,
    // /edl/customers/{customerId}
    /^\/edl?\/customers?\/edl/,
    */
    /*
    ^    => beginning of string
    (?!) => negative look-ahead
    \/?  => 0 or 1 slash
    .+   => 1 or more character (any except newline) 
    $    => end of string
    */
    /^(?=\/?api).+$/gm
]
let isMatch = (valids, str) => {
    return valids.some((pattern) => { return pattern.test(str) })
}
let str;
//str = '/edl/customers/EDL-2020050500001/staffs/M0002'
//str = '/edl/users/edl'
//str = '/edl/customers'
//str = '/edl/customers/'
str = '/api' // valid
str = '/' // invalid
str = '/api' // invalid
let isValid = isMatch(validUrls, str)

console.log('is valid:', isValid)

// /(edl|api)((\/customers(\/\S+(\/(branchs|orgs))))|(\/users))
/*
/edl/customers
/edl/customers/EDL-2020050500001/branchs
/edl/users
/edl/customers/EDL-2020050500001/orgs
/api
/api/customers
*/