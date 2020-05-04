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
    // /edl/customers/{customerId}
    /\/(edl|api)(\/(customers|users)(\/EDL-\w+(\/(branchs|orgs)(\/(B|O)\w+)*))*)*/gm
]
let isMatch = (valids, str) => {
    return valids.some((pattern) => { 
        console.log(pattern)
        let ret = pattern.test(str) 
        if (ret) {
            let result = str.match(pattern)
            console.log(result)
        }
        return ret
    })
}
let str;
//str = '/edl/customers/EDL-2020050500001/staffs/M0002'
str = '/api' // --> PASS
str = '/edl/customers' // --> PASS
str = '/edl/customers/EDL-2020050500003/xxx'
str = '/edl/customers/EDL-2020050500001/branchs'
str = '/edl/customers/EDL-2020050500003/branchs/B001'
str = '/edl/customers/EDL-2020050500003/sample/X001'
//str = '/xxx'

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