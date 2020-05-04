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
    // /edl/customers
    /^\/edl?\/customers/,
    // /edl/customers/{customerId}
    /\/edl(\/(customers|users)(\/EDL-\w+(\/(branchs|orgs)(\/(B|O)\w+)*))*)*/gm,
    /\/api(\/(customers|users)(\/EDL-\w+(\/(branchs|orgs)(\/(B|O)\w+)*))*)*/gm
]
let isMatch = (valids, str) => {
    return valids.some((pattern) => { return pattern.test(str) })
}
let str;
//str = '/edl/customers/EDL-2020050500001/staffs/M0002'
str = '/api' // --> PASS
set = '/edl/customers' // --> PASS
set = '/edl/customers/EDL-2020050500003/xxx'
set = '/edl/customers/EDL-2020050500001/branchs'
set = '/edl/customers/EDL-2020050500003/branchs/B001'
set = '/edl/customers/EDL-2020050500003/sample/X001'
set = '/edl/user'

let isValid = isMatch(validUrls, str)
console.log('is valid:', isValid)

// \/(edl|api)(\/(customers|users)(\/EDL-\w+(\/(branchs|orgs)(\/(B|O)\w+)*))*)*
/*
/edl/customers
/edl/customers/EDL-2020050500001/branchs
/edl/customers/EDL-2020050500003/branchs/B001
/edl/users
/edl/customers/EDL-2020050500001/orgs
/edl/customers/EDL-2020050500004/orgs/O001
/api
/api/customers
*/