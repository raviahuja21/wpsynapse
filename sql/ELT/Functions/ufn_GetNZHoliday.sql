CREATE FUNCTION [ELT].[ufn_GetNZHoliday] (@iDate [date]) RETURNS varchar(250)
AS
begin

         --, @iDate Date
         --set @iDate = DATEADD(month,((2003 - 1900) * 12) + 6 -1, 4 - 1) --getDate()+1100
         --	set DATEFIRST 1;		-- set 1 to a monday or 7 to sunday

         declare @result varchar(250), @dayofweek varchar(3), @cmon varchar(3), @ctue varchar(3), @cwed varchar(3), @cthu varchar(3), @cfri varchar(3), @mmdd varchar(4), @qbirthday date, @lday date, @thisyear int, @efri date, @emon date, @esun date, @lDate date, @lauck date, @lcantsth date, @lcant date, @lchat date, @lhawk date, @lmarl date, @lnels date, @lotago date, @lsthld date, @lnaki date, @lwlg date, @lwest date, @D0 date= cast('1900-01-01' as date);
         set @cmon = 'MON';
         set @ctue = 'TUE';
         set @cwed = 'WED';
         set @cthu = 'THU';
         set @cfri = 'FRI';

/*
 easter variables
*/

         declare @c int, @n int, @k int, @i int, @j int, @l int, @m int, @d int;
         set @result = null;
         set @dayofweek = upper(left(DATENAME(weekday, @iDate), 3));
         set @thisyear = year(@iDate);

/*
Queen's Birthday 1st Monday in June
*/

         set @qbirthday = cast('6 Jun'+DATENAME(YEAR, @iDate) as date);
         set @qbirthday = dateadd(Week, datediff(Week, @D0, @qbirthday), @D0);

/*
Labour Day 4th Monday in October
*/

         set @lday = cast('1 Oct'+DATENAME(YEAR, @iDate) as date);
         set @lday = case
                     -- if first monday of the month is Oct then add 3 weeks otherwise add 4 weeks
                         when cast(dateadd(Week, datediff(Week, @D0, @lday), @D0) as date) >= @lday
                         then dateadd(Week, datediff(Week, @D0, @lday) + 3, @D0)
                         else dateadd(Week, datediff(Week, @D0, @lday) + 4, @D0)
                     end;

/*
Auckland anniversary - Monday nearest to the actual day of 29 January
*/

         set @lDate = cast('29 Jan'+DATENAME(YEAR, @iDate) as date);
         set @lauck = case
                          when abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), @D0))) < abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), 7)))
                          then dateadd(Week, datediff(Week, @D0, @lDate), @D0)
                          else dateadd(Week, datediff(Week, @D0, @lDate), 7)
                      end;

/*
Canterbury (South) Anniversary 4th Monday in September
*/

         set @lcantsth = cast('1 Sep'+DATENAME(YEAR, @iDate) as date);
         set @lcantsth = case
                         -- if first monday of the month is Sep then add 3 weeks otherwise add 4 weeks
                             when dateadd(Week, datediff(Week, @D0, @lcantsth), @D0) >= @lcantsth
                             then dateadd(Week, datediff(Week, @D0, @lcantsth) + 3, @D0)
                             else dateadd(Week, datediff(Week, @D0, @lcantsth) + 4, @D0)
                         end;

/*
The definition for the Canterbury Anniversary Day celebration as decided by Christchurch City is the second Friday after the first Tuesday in November each year.

DATEADD(Week, DATEDIFF(Week,@D0,@lcant), 0) is first month of Date param. Second Friday is total of 18 days after first monday.
*/

         set @lcant = cast('5 Nov'+DATENAME(YEAR, @iDate) as date);
         set @lcant = dateadd(Week, datediff(Week, @D0, @lcant), 11);

/*
Chatham Islands anniversary - Monday nearest to the actual day of November 30
*/

         set @lDate = cast('30 Nov'+DATENAME(YEAR, @iDate) as date);
         set @lchat = case
                          when abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), @D0))) < abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), 7)))
                          then dateadd(Week, datediff(Week, @D0, @lDate), @D0)
                          else dateadd(Week, datediff(Week, @D0, @lDate), 7)
                      end;

/*
Hawke's Bay anniversary - Friday before Labour Day
*/

         set @lhawk = dateadd(dd, -3, @lday);

/*
Marlborough anniversary - First Monday after Labour Day
*/

         set @lmarl = dateadd(dd, 7, @lday);

/*
Nelson anniversary - Monday nearest to the actual day of February 1
*/

         set @lDate = cast('1 Feb'+DATENAME(YEAR, @iDate) as date);
         set @lnels = case
                          when abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), @D0))) < abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), 7)))
                          then dateadd(Week, datediff(Week, @D0, @lDate), @D0)
                          else dateadd(Week, datediff(Week, @D0, @lDate), 7)
                      end;

/*
Otago anniversary - Monday nearest to the actual day of March 23
*/

         set @lDate = cast('23 Mar'+DATENAME(YEAR, @iDate) as date);
         set @lotago = case
                           when abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), @D0))) < abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), 7)))
                           then dateadd(Week, datediff(Week, @D0, @lDate), @D0)
                           else dateadd(Week, datediff(Week, @D0, @lDate), 7)
                       end;

/*
Southland anniversary - Monday nearest to the actual day of January 17
*/

         set @lDate = cast('17 Jan'+DATENAME(YEAR, @iDate) as date);
         set @lsthld = case
                           when abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), @D0))) < abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), 7)))
                           then dateadd(Week, datediff(Week, @D0, @lDate), @D0)
                           else dateadd(Week, datediff(Week, @D0, @lDate), 7)
                       end;

/*
Taranaki Anniversary - Second Monday in March – to avoid Easter
*/

         set @lnaki = cast('6 Mar'+DATENAME(YEAR, @iDate) as date);
         set @lnaki = dateadd(Week, datediff(Week, @D0, @lnaki), 7);

/*
Wellington anniversary - Monday nearest to the actual day of January 22
*/

         set @lDate = cast('22 Jan'+DATENAME(YEAR, @iDate) as date);
         set @lwlg = case
                         when abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), @D0))) < abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), 7)))
                         then dateadd(Week, datediff(Week, @D0, @lDate), @D0)
                         else dateadd(Week, datediff(Week, @D0, @lDate), 7)
                     end;

/*
Westland anniversary - Monday nearest to the actual day of December 1
*/

         set @lDate = cast('1 Dec'+DATENAME(YEAR, @iDate) as date);
         set @lwest = case
                          when abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), @D0))) < abs(datediff(dd, @lDate, dateadd(Week, datediff(Week, @D0, @lDate), 7)))
                          then dateadd(Week, datediff(Week, @D0, @lDate), @D0)
                          else dateadd(Week, datediff(Week, @D0, @lDate), 7)
                      end;

/*
Easter:
The rule is that Easter is the first Sunday after the first ecclesiastical full moon
that occurs on or after March 21. The lunar cycles used by the ecclesiastical system
are simple to program. The following algorithm will compute the Date of Easter
in the Gregorian Calendar system.

Please note the following: This is an integer calculation.
All variables are integers and all remainders from division are dropped.

The algorithm uses the year, y, to give the month, m, and day, d, of Easter.
The symbol * means multiply.

    c = y / 100
    n = y - 19 * ( y / 19 )
    k = ( c - 17 ) / 25
    i = c - c / 4 - ( c - k ) / 3 + 19 * n + 15
    i = i - 30 * ( i / 30 )
    i = i - ( i / 28 ) * ( 1 - ( i / 28 ) * ( 29 / ( i + 1 ) )
        * ( ( 21 - n ) / 11 ) )
    j = y + y / 4 + i + 2 - c + c / 4
    j = j - 7 * ( j / 7 )
    l = i - j
    m = 3 + ( l + 40 ) / 44
    d = l + 28 - 31 * ( m / 4 )


For example, using the year 2010,
y=2010,
c=2010/100=20,
n=2010 - 19 x (2010/19) = 15,
etc. resulting in Easter Sunday on April 4, 2010.
*/

         set @c = cast(@thisyear / 100 as int);
         set @n = @thisyear - 19 * cast(@thisyear / 19 as int);
         set @k = cast((@c - 17) / 25 as int);
         set @i = @c - cast(@c / 4 as int) - cast((@c - @k) / 3 as int) + 19 * @n + 15;
         set @i = @i - 30 * cast(@i / 30 as int);
         set @i = @i - cast(@i / 28 as int) * (1 - cast(@i / 28 as int) * cast(29 / (@i + 1) as int) * cast((21 - @n) / 11 as int));
         set @j = @thisyear + cast(@thisyear / 4 as int) + @i + 2 - @c + cast(@c / 4 as int);
         set @j = @j - 7 * cast(@j / 7 as int);
         set @l = @i - @j;
         set @m = 3 + cast((@l + 40) / 44 as int);
         set @d = @l + 28 - 31 * cast(@m / 4 as int);
         set @esun = cast(dateadd(month, ((@thisyear - 1900) * 12) + @m - 1, @d - 1) as date);
         set @emon = dateadd(DAY, 1, @esun);
         set @efri = dateadd(DAY, -3, @emon);
         set @mmdd = right(convert(varchar(10), @iDate, 112), 4);

/*
 Anzac Day is 25th april.
If  Anzac Day is a Saturday or a Sunday the holiday will be ovserved on following Monday.
*/

         set @result = case
                           when @mmdd = '0425'
                           then 'ANZAC Day'
                           when @mmdd in('0426', '0427')
                                and @dayofweek = @cmon
                           then 'Observed ANZAC Day'

/*
 Waitangi Day february 6.
If  Waitangi Day is a Saturday or a Sunday the holiday will be ovserved on following Monday.
*/

                           when @mmdd = '0206'
                           then 'Waitangi Day'
                           when @mmdd in('0207', '0208')
                                and @dayofweek = @cmon
                           then 'Observed Waitangi Day'

/*
New Year's Day - 1 January
Day after New Year's Day - 2 January

If New Year's Day is either a Monday, Tuesday, Wednesday or Thursday, then it is observed on that day and the following day is also observed as a holiday.
If New Year's Day is a Friday, the Friday becomes a holiday, and also the following Monday.
If New Year's Day is either a Saturday or a Sunday, then a public holiday is held on the following Monday and Tuesday.
*/

                       --					  WHEN @mmdd = '0101' AND @dayofweek IN (@cmon, @ctue, @cwed, @cthu, @cfri) THEN
                           when @mmdd = '0101'
                           then 'New Year''s Day'
                       --					  WHEN @mmdd = '0102' THEN
                       --						  CASE
                       --							  WHEN @dayofweek IN (@ctue, @cwed, @cthu, @cfri) THEN
                       --								  'Day After New Year''s Day'
                       --							  WHEN @dayofweek = @cmon THEN
                       --								  'Observed New Year''s Day'
                       --						  END
                           when @mmdd = '0102'
                           then case
                                    when @dayofweek = @cmon
                                    then 'Day After New Year''s Day, Observed New Year''s Day'
                                    else 'Day After New Year''s Day'
                                end
                           when @mmdd = '0103'
                           then case
                                    when @dayofweek = @cmon
                                    then 'Observed New Years Day'
                                    when @dayofweek = @ctue
                                    then 'Day After Observed New Year''s Day'
                                end
                           when @mmdd = '0104'
                           then case
                                    when @dayofweek in(@cmon, @ctue)
                                    then 'Day After Observed New Year''s Day'
                                end

/*
Christmas Day - 25 December
Day after Christmas Day - 26 December

If Christmas Dayis either a Monday, Tuesday, Wednesday or Thursday, then it is observed on that day and the following day is also observed as a holiday.
If Christmas Day is a Friday, the Friday becomes a holiday, and also the following Monday.
If Christmas Day is either a Saturday or a Sunday, then a public holiday is held on the following Monday and Tuesday.
*/

                       --					  WHEN @mmdd = '1225' AND @dayofweek IN (@cmon, @ctue, @cwed, @cthu, @cfri) THEN
                           when @mmdd = '1225'
                           then 'Christmas Day'
                       --					  WHEN @mmdd = '1226' THEN
                       --						  CASE
                       --							  WHEN @dayofweek IN (@ctue, @cwed, @cthu, @cfri) THEN
                       --								  'Boxing Day'
                       --							  WHEN @dayofweek = @cmon THEN
                       --								  'Christmas Day'
                       --						  END
                           when @mmdd = '1226'
                           then case
                                    when @dayofweek = @cmon
                                    then 'Boxing Day, Observed Christmas Day'
                                    else 'Boxing Day'
                                end
                           when @mmdd = '1227'
                           then case
                                    when @dayofweek = @cmon
                                    then 'Observed Christmas Day'
                                    when @dayofweek = @ctue
                                    then 'Observed Boxing Day'
                                end
                           when @mmdd = '1228'
                           then case
                                    when @dayofweek in(@cmon, @ctue)
                                    then 'Observed Boxing Day'
                                end

/*
Queen's Birthday 1st Monday in June The Date that New Zealand observes the Queen's birthday.
Queen Elizabeth II's actual birthday is 21 April 1926.
*/

                           when @iDate = @qbirthday
                           then 'Queen''s Birthday'

/*
Labour Day 4th Monday in October
*/

                           when @iDate = @lday
                           then 'Labour Day'

/*
Easter:
The rule is that Easter is the first Sunday after the first ecclesiastical full moon
that occurs on or after March 21. The lunar cycles used by the ecclesiastical system
are simple to program.
*/

                           when @iDate = @efri
                           then 'Easter Friday'
                           when @iDate = @esun
                           then 'Easter Sunday'
                           when @iDate = @emon
                           then 'Easter Monday'
                       end;

         -- province holidays. multiple province holidays may fall on the same day. if so, return comma separated.
         --Auckland anniversary
         if @iDate = @lauck
             begin
                 set @result = case
                                   when @result is null
                                   then 'Auckland Anniversary'
                                   else @result+', '+'Auckland Anniversary'
                               end
             end;

         --Canterbury (South) Anniversary 
         if @iDate = @lcantsth
             begin
                 set @result = case
                                   when @result is null
                                   then 'Canterbury (South) Anniversary'
                                   else @result+', '+'Canterbury (South) Anniversary'
                               end
             end;

         --Canterbury Anniversary 

         if @iDate = @lcant
             begin
                 set @result = case
                                   when @result is null
                                   then 'Canterbury Anniversary'
                                   else @result+', '+'Canterbury Anniversary'
                               end
             end;

         --Chatham Islands Anniversary 

         if @iDate = @lchat
             begin
                 set @result = case
                                   when @result is null
                                   then 'Chatham Islands Anniversary'
                                   else @result+', '+'Chatham Islands Anniversary'
                               end
             end;

         --Hawke's Bay Anniversary 
         if @iDate = @lhawk
             begin
                 set @result = case
                                   when @result is null
                                   then 'Hawke''s Bay Anniversary'
                                   else @result+', '+'Hawke''s Bay Anniversary'
                               end
             end;

         --Marlborough Anniversary 
         if @iDate = @lmarl
             begin
                 set @result = case
                                   when @result is null
                                   then 'Marlborough Anniversary'
                                   else @result+', '+'Marlborough Anniversary'
                               end
             end;

         --Nelson Anniversary 
         if @iDate = @lnels
             begin
                 set @result = case
                                   when @result is null
                                   then 'Nelson Anniversary'
                                   else @result+', '+'Nelson Anniversary'
                               end
             end;

         --Otago Anniversary 
         if @iDate = @lotago
             begin
                 set @result = case
                                   when @result is null
                                   then 'Otago Anniversary'
                                   else @result+', '+'Otago Anniversary'
                               end
             end;

         --Southland Anniversary 
         if @iDate = @lsthld
             begin
                 set @result = case
                                   when @result is null
                                   then 'Southland Anniversary'
                                   else @result+', '+'Southland Anniversary'
                               end
             end;

         --Taranaki Anniversary 
         if @iDate = @lnaki
             begin
                 set @result = case
                                   when @result is null
                                   then 'Taranaki Anniversary'
                                   else @result+', '+'Taranaki Anniversary'
                               end
             end;

         --Wellington Anniversary 
         if @iDate = @lwlg
             begin
                 set @result = case
                                   when @result is null
                                   then 'Wellington Anniversary'
                                   else @result+', '+'Wellington Anniversary'
                               end
             end;

         --Westland Anniversary 
         if @iDate = @lwest
             begin
                 set @result = case
                                   when @result is null
                                   then 'Westland Anniversary'
                                   else @result+', '+'Westland Anniversary'
                               end
             end;

         --Return result
         return @result;
     end
GO

