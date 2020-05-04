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
    /^\/edl\/customers/,
    // /edl/customers/{customerId}
    /^\/edl\/customers\/edl/,
]
let isMatch = (valids, str) => {
    return valids.some((pattern) => { return pattern.test(str) })
}
let str;
str = '/edl/customers/EDL-2020050500001/staffs/M0002'
str = '/edl/users/edl'
str = '/edl/customers'
str = '/edl/customers/EDL-202005050000'
let isValid = isMatch(validUrls, str)

console.log('is valid:', isValid)