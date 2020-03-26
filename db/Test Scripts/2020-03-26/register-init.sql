/*
-- Register Basic Company.
DECLARE @customerId nvarchar(30)

EXEC Register N'Softbase Co., Ltd.'
            , N'admin@softbase.co.th'
			, 1234
			, 3
			, @customerId out
			--, @memberId out, @branchId out, @orgId out, @errNum out, @errMsg out;

SELECT @customerId;

EXEC InitSampleData @customerId;
*/

/*

SET @customerId = 'EDL-C2020030001'

SELECT * FROM Customer WHERE CustomerId = @customerId
SELECT * FROM Branch WHERE CustomerId =@customerId
SELECT * FROM Org WHERE CustomerId = @customerId
SELECT * FROM MemberInfo WHERE CustomerId = @customerId
SELECT * FROM Device WHERE CustomerId = @customerId

SELECT * FROM QSet WHERE CustomerId = @customerId
SELECT * FROM QSlide WHERE CustomerId = @customerId
SELECT * FROM QSlideItem WHERE CustomerId = @customerId
*/
