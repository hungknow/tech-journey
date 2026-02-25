## SQL

### 1. Join / Aggregate

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0175 | [Combine Two Tables](./problems/0175-combine-two-tables.md) | [MySQL](./MySQL/combine-two-tables.sql) | _O(m + n)_   | _O(m + n)_ | Easy     ||
| 0176 | [Second Highest Salary](./problems/0176-second-highest-salary.md) | [MySQL](./MySQL/second-highest-salary.sql) | _O(n)_ | _O(1)_ | Easy         ||
| 0177 | [Nth Highest Salary](./problems/0177-nth-highest-salary.md) | [MySQL](./MySQL/nth-highest-salary.sql) | _O(n^2)_   | _O(n)_ | Medium         ||
| 0182 | [Duplicate Emails](./problems/0182-duplicate-emails.md) | [MySQL](./MySQL/duplicate-emails.sql) | _O(n^2)_ | _O(n)_       | Easy           ||
| 0184 | [Department Highest Salary](./problems/0184-department-highest-salary.md) | [MySQL](./MySQL/department-highest-salary.sql) | _O(n^2)_   | _O(n)_ | Medium         ||
| 0185 | [Department Top Three Salaries](./problems/0185-department-top-three-salaries.md) | [MySQL](./MySQL/department-top-three-salaries.sql) | _O(n^2)_   | _O(n)_ | Hard         ||
| 0196 | [Delete Duplicate Emails](./problems/0196-delete-duplicate-emails.md) | [MySQL](./MySQL/delete-duplicate-emails.sql) | _O(n^2)_ | _O(n)_       | Easy           ||
| 0569 | [Median Employee Salary](./problems/0569-median-employee-salary.md) | [MySQL](./MySQL/median-employee-salary.sql) | _O(nlogn)_ | _O(n)_       | Hard         |🔒||
| 0579 | [Find Cumulative Salary of an Employee](./problems/0579-find-cumulative-salary-of-an-employee.md) | [MySQL](./MySQL/find-cumulative-salary-of-an-employee.sql) | _O(n^2)_ | _O(n)_       | Hard           |🔒||
| 0580 | [Count Student Number in Departments](./problems/0580-count-student-number-in-departments.md) | [MySQL](./MySQL/count-student-number-in-departments.sql) | _O(s + dlogd)_ | _O(s + d)_       | Medium         |🔒||
| 0615 | [Average Salary: Departments VS Company](./problems/0615-average-salary-departments-vs-company.md) | [MySQL](./MySQL/average-salary-departments-vs-company.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 0627 | [Swap Salary](./problems/0627-swap-salary.md) | [MySQL](./MySQL/swap-salary.sql) | _O(n)_ | _O(1)_       | Easy           |  ||
| 1179 | [Reformat Department Table](./problems/1179-reformat-department-table.md) | [MySQL](./MySQL/reformat-department-table.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1350 | [Students With Invalid Departments](./problems/1350-students-with-invalid-departments.md) | [MySQL](./MySQL/students-with-invalid-departments.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1789 | [Primary Department for Each Employee](./problems/1789-primary-department-for-each-employee.md) | [MySQL](./MySQL/primary-department-for-each-employee.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1875 | [Group Employees of the Same Salary](./problems/1875-group-employees-of-the-same-salary.md) | [MySQL](./MySQL/group-employees-of-the-same-salary.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 1907 | [Count Salary Categories](./problems/1907-count-salary-categories.md) | [MySQL](./MySQL/count-salary-categories.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 2988 | [Manager of the Largest Department](./problems/2988-manager-of-the-largest-department.md) | [MySQL](./MySQL/manager-of-the-largest-department.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||

---

### 2. Window / Rank

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0178 | [Rank Scores](./problems/0178-rank-scores.md) | [MySQL](./MySQL/rank-scores.sql) | _O(n^2)_        | _O(n)_          | Medium         ||
| 1193 | [Monthly Transactions I](./problems/1193-monthly-transactions-i.md) | [MySQL](./MySQL/monthly-transactions-i.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1205 | [Monthly Transactions II](./problems/1205-monthly-transactions-ii.md) | [MySQL](./MySQL/monthly-transactions-ii.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1308 | [Running Total for Different Genders](./problems/1308-running-total-for-different-genders.md) | [MySQL](./MySQL/running-total-for-different-genders.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒| |
| 1495 | [Friendly Movies Streamed Last Month](./problems/1495-friendly-movies-streamed-last-month.md) | [MySQL](./MySQL/friendly-movies-streamed-last-month.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1565 | [Unique Orders and Customers Per Month](./problems/1565-unique-orders-and-customers-per-month.md) | [MySQL](./MySQL/unique-orders-and-customers-per-month.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 2175 | [The Change in Global Rankings](./problems/2175-the-change-in-global-rankings.md) | [MySQL](./MySQL/the-change-in-global-rankings.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2346 | [Compute the Rank as a Percentage](./problems/2346-compute-the-rank-as-a-percentage.md) | [MySQL](./MySQL/compute-the-rank-as-a-percentage.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2669 | [Count Artist Occurrences On Spotify Ranking List](./problems/2669-count-artist-occurrences-on-spotify-ranking-list.md) | [MySQL](./MySQL/count-artist-occurrences-on-spotify-ranking-list.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||

---

### 3. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0180 | [Consecutive Numbers](./problems/0180-consecutive-numbers.md) | [MySQL](./MySQL/consecutive-numbers.sql) | _O(n)_   | _O(n)_ | Medium         ||
| 0181 | [Employees Earning More Than Their Managers](./problems/0181-employees-earning-more-than-their-managers.md) | [MySQL](./MySQL/employees-earning-more-than-their-managers.sql) | _O(n^2)_   | _O(1)_ | Easy     ||
| 0183 | [Customers Who Never Order](./problems/0183-customers-who-never-order.md) | [MySQL](./MySQL/customers-who-never-order.sql) | _O(n^2)_ | _O(1)_       | Easy           ||
| 0197 | [Rising Temperature](./problems/0197-rising-temperature.md) | [MySQL](./MySQL/rising-temperature.sql) | _O(n^2)_ | _O(n)_       | Easy           ||
| 0262 | [Trips and Users](./problems/0262-trips-and-users.md) | [MySQL](./MySQL/trips-and-users.sql) | _O((t * u) + tlogt)_ | _O(t)_       | Hard           ||
| 0511 | [Game Play Analysis I](./problems/0511-game-play-analysis-i.md) | [MySQL](./MySQL/game-play-analysis-i.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 0512 | [Game Play Analysis II](./problems/0512-game-play-analysis-ii.md) | [MySQL](./MySQL/game-play-analysis-ii.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 0534 | [Game Play Analysis III](./problems/0534-game-play-analysis-iii.md) | [MySQL](./MySQL/game-play-analysis-iii.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒| |
| 0550 | [Game Play Analysis IV](./problems/0550-game-play-analysis-iv.md) | [MySQL](./MySQL/game-play-analysis-iv.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 0570 | [Managers with at Least 5 Direct Reports](./problems/0570-managers-with-at-least-5-direct-reports.md) | [MySQL](./MySQL/managers-with-at-least-5-direct-reports.sql) | _O(n)_ | _O(n)_       | Medium         |🔒||
| 0571 | [Find Median Given Frequency of Numbers](./problems/0571-find-median-given-frequency-of-numbers.md) | [MySQL](./MySQL/find-median-given-frequency-of-numbers.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 0574 | [Winning Candidate](./problems/0574-winning-candidate.md) | [MySQL](./MySQL/winning-candidate.sql) | _O(nlogn)_ | _O(n)_       | Medium         |🔒||
| 0577 | [Employee Bonus](./problems/0577-employee-bonus.md) | [MySQL](./MySQL/employee-bonus.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 0578 | [Get Highest Answer Rate Question](./problems/0578-get-highest-answer-rate-question.md) | [MySQL](./MySQL/get-highest-answer-rate-question.sql) | _O(nlogn)_ | _O(n)_       | Medium         |🔒||
| 0584 | [Find Customer Referee](./problems/0584-find-customer-referee.md) | [MySQL](./MySQL/find-customer-referee.sql) | _O(n)_ | _O(1)_       | Easy           |🔒||
| 0585 | [Investments in 2016](./problems/0585-investments-in-2016.md) | [MySQL](./MySQL/investments-in-2016.sql) | _O(n^2)_ | _O(n)_       | Medium         |🔒||
| 0586 | [Customer Placing the Largest Number of Orders](./problems/0586-customer-placing-the-largest-number-of-orders.md) | [MySQL](./MySQL/customer-placing-the-largest-number-of-orders.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 0595 | [Big Countries](./problems/0595-big-countries.md) | [MySQL](./MySQL/big-countries.sql) | _O(n)_ | _O(1)_       | Easy           |  ||
| 0596 | [Classes More Than 5 Students](./problems/0596-classes-more-than-5-students.md) | [MySQL](./MySQL/classes-more-than-5-students.sql) | _O(n)_ | _O(n)_       | Easy           |  ||
| 0597 | [Friend Requests I: Overall Acceptance Rate](./problems/0597-friend-requests-i-overall-acceptance-rate.md) | [MySQL](./MySQL/friend-requests-i-overall-acceptance-rate.sql) | _O(rlogr + aloga)_ | _O(r + a)_       | Easy           |🔒||
| 0601 | [Human Traffic of Stadium](./problems/0601-human-traffic-of-stadium.md) | [MySQL](./MySQL/human-traffic-of-stadium.sql) | _O(n^3)_ | _O(n^3)_       | Hard           |  ||
| 0602 | [Friend Requests II: Who Has the Most Friends](./problems/0602-friend-requests-ii-who-has-the-most-friends.md) | [MySQL](./MySQL/friend-requests-ii-who-has-the-most-friends.sql) | _O(nlogn)_ | _O(n)_       | Medium         |🔒||
| 0603 | [Consecutive Available Seats](./problems/0603-consecutive-available-seats.md) | [MySQL](./MySQL/consecutive-available-seats.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒| Window Function |
| 0607 | [Sales Person](./problems/0607-sales-person.md) | [MySQL](./MySQL/sales-person.sql) | _O(s * o)_ | _O(s + o)_       | Easy           |🔒||
| 0608 | [Tree Node](./problems/0608-tree-node.md) | [MySQL](./MySQL/tree-node.sql) | _O(n^2)_ | _O(n)_       | Medium         |🔒||
| 0610 | [Triangle Judgement](./problems/0610-triangle-judgement.md) | [MySQL](./MySQL/triangle-judgement.sql) | _O(n)_ | _O(1)_       | Easy           |🔒||
| 0612 | [Shortest Distance in a Plane](./problems/0612-shortest-distance-in-a-plane.md) | [MySQL](./MySQL/shortest-distance-in-a-plane.sql) | _O(n^2)_ | _O(n^2)_       | Medium         |🔒||
| 0613 | [Shortest Distance in a Line](./problems/0613-shortest-distance-in-a-line.md) | [MySQL](./MySQL/shortest-distance-in-a-line.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 0614 | [Second Degree Follower](./problems/0614-second-degree-follower.md) | [MySQL](./MySQL/second-degree-follower.sql) | _O(nlogn)_ | _O(n)_       | Medium         |🔒||
| 0618 | [Students Report By Geography](./problems/0618-students-report-by-geography.md) | [MySQL](./MySQL/students-report-by-geography.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 0619 | [Biggest Single Number](./problems/0619-biggest-single-number.md) | [MySQL](./MySQL/biggest-single-number.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 0620 | [Not Boring Movies](./problems/0620-not-boring-movies.md) | [MySQL](./MySQL/not-boring-movies.sql) | _O(nlogn)_ | _O(1)_       | Easy           |  ||
| 0626 | [Exchange Seats](./problems/0626-exchange-seats.md) | [MySQL](./MySQL/exchange-seats.sql) | _O(nlogn)_ | _O(n)_       | Medium         |  ||
| 1045 | [Customers Who Bought All Products](./problems/1045-customers-who-bought-all-products.md) | [MySQL](./MySQL/customers-who-bought-all-products.sql) | _O(n + k)_ | _O(n + k)_       | Medium           |🔒| |
| 1050 | [Actors and Directors Who Cooperated At Least Three Times](./problems/1050-actors-and-directors-who-cooperated-at-least-three-times.md) | [MySQL](./MySQL/actors-and-directors-who-cooperated-at-least-three-times.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1068 | [Product Sales Analysis I](./problems/1068-product-sales-analysis-i.md) | [MySQL](./MySQL/product-sales-analysis-i.sql) | _O(m + n)_ | _O(m + n)_       | Easy           |🔒| |
| 1069 | [Product Sales Analysis II](./problems/1069-product-sales-analysis-ii.md) | [MySQL](./MySQL/product-sales-analysis-ii.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1070 | [Product Sales Analysis III](./problems/1070-product-sales-analysis-iii.md) | [MySQL](./MySQL/product-sales-analysis-iii.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1075 | [Project Employees I](./problems/1075-project-employees-i.md) | [MySQL](./MySQL/project-employees-i.sql) | _O(m + n)_ | _O(m + n)_       | Easy           |🔒| |
| 1076 | [Project Employees II](./problems/1076-project-employees-ii.md) | [MySQL](./MySQL/project-employees-ii.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1077 | [Project Employees III](./problems/1077-project-employees-iii.md) | [MySQL](./MySQL/project-employees-iii.sql) | _O((m + n)^2)_ | _O(m + n)_       | Medium           |🔒| |
| 1082 | [Sales Analysis I](./problems/1082-sales-analysis-i.md) | [MySQL](./MySQL/sales-analysis-i.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1083 | [Sales Analysis II](./problems/1083-sales-analysis-ii.md) | [MySQL](./MySQL/sales-analysis-ii.sql) | _O(m + n)_ | _O(m + n)_       | Easy           |🔒| |
| 1084 | [Sales Analysis III](./problems/1084-sales-analysis-iii.md) | [MySQL](./MySQL/sales-analysis-iii.sql) | _O(m + n)_ | _O(m + n)_       | Easy           |🔒| |
| 1097 | [Game Play Analysis V](./problems/1097-game-play-analysis-v.md) | [MySQL](./MySQL/game-play-analysis-v.sql) | _O(n^2)_ | _O(n)_       | Hard           |🔒| |
| 1098 | [Unpopular Books](./problems/1098-unpopular-books.md) | [MySQL](./MySQL/unpopular-books.sql) | _O(m + n)_ | _O(n)_       | Medium           |🔒| |
| 1107 | [New Users Daily Count](./problems/1107-new-users-daily-count.md) | [MySQL](./MySQL/new-users-daily-count.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1112 | [Highest Grade For Each Student](./problems/1112-highest-grade-for-each-student.md) | [MySQL](./MySQL/highest-grade-for-each-student.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒| |
| 1113 | [Reported Posts](./problems/1113-reported-posts.md) | [MySQL](./MySQL/reported-posts.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1126 | [Active Businesses](./problems/1126-active-businesses.md) | [MySQL](./MySQL/active-businesses.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1132 | [Reported Posts II](./problems/1132-reported-posts-ii.md) | [MySQL](./MySQL/reported-posts-ii.sql) | _O(m + n)_ | _O(n)_       | Medium           |🔒| |
| 1141 | [User Activity for the Past 30 Days I](./problems/1141-user-activity-for-the-past-30-days-i.md) | [MySQL](./MySQL/user-activity-for-the-past-30-days-i.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1142 | [User Activity for the Past 30 Days II](./problems/1142-user-activity-for-the-past-30-days-ii.md) | [MySQL](./MySQL/user-activity-for-the-past-30-days-ii.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1148 | [Article Views I](./problems/1148-article-views-i.md) | [MySQL](./MySQL/article-views-i.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒| |
| 1149 | [Article Views II](./problems/1149-article-views-ii.md) | [MySQL](./MySQL/article-views-ii.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒| |
| 1158 | [Market Analysis I](./problems/1158-market-analysis-i.md) | [MySQL](./MySQL/market-analysis-i.sql) | _O(m + n)_ | _O(m + n)_       | Medium           |🔒| |
| 1159 | [Market Analysis II](./problems/1159-market-analysis-ii.md) | [MySQL](./MySQL/market-analysis-ii.sql) | _O(m + n)_ | _O(m + n)_       | Hard           |🔒| |
| 1164 | [Product Price at a Given Date](./problems/1164-product-price-at-a-given-date.md) | [MySQL](./MySQL/product-price-at-a-given-date.sql) | _O(mlogn)_ | _O(m)_       | Medium           |🔒| |
| 1173 | [Immediate Food Delivery I](./problems/1173-immediate-food-delivery-i.md) | [MySQL](./MySQL/immediate-food-delivery-i.sql) | _O(n)_ | _O(1)_       | Easy           |🔒| |
| 1174 | [Immediate Food Delivery II](./problems/1174-immediate-food-delivery-ii.md) | [MySQL](./MySQL/immediate-food-delivery-ii.sql) | _O(n)_ | _O(m)_       | Medium           |🔒| |
| 1194 | [Tournament Winners](./problems/1194-tournament-winners.md) | [MySQL](./MySQL/tournament-winners.sql) | _O(m + n + nlogn)_ | _O(m + n)_       | Hard           |🔒| |
| 1204 | [Last Person to Fit in the Elevator](./problems/1204-last-person-to-fit-in-the-elevator.md) | [MySQL](./MySQL/last-person-to-fit-in-the-elevator.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒| |
| 1211 | [Queries Quality and Percentage](./problems/1211-queries-quality-and-percentage.md) | [MySQL](./MySQL/queries-quality-and-percentage.sql) | _O(n)_ | _O(n)_       | Easy           || |
| 1212 | [Team Scores in Football Tournament](./problems/1212-team-scores-in-football-tournament.md) | [MySQL](./MySQL/team-scores-in-football-tournament.sql) | _O(nlogn)_ | _O(n)_       | Medium           || |
| 1225 | [Report Contiguous Dates](./problems/1225-report-contiguous-dates.md) | [MySQL](./MySQL/report-contiguous-dates.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒| |
| 1241 | [Number of Comments per Post](./problems/1241-number-of-comments-per-post.md) | [MySQL](./MySQL/number-of-comments-per-post.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1251 | [Average Selling Price](./problems/1251-average-selling-price.md) | [MySQL](./MySQL/average-selling-price.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1264 | [Page Recommendations](./problems/1264-page-recommendations.md) | [MySQL](./MySQL/page-recommendations.sql) | _O(m + n)_ | _O(m)_       | Medium           |🔒| |
| 1270 | [All People Report to the Given Manager](./problems/1270-all-people-report-to-the-given-manager.md) | [MySQL](./MySQL/all-people-report-to-the-given-manager.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1280 | [Students and Examinations](./problems/1280-students-and-examinations.md) | [MySQL](./MySQL/students-and-examinations.sql) | _O((m * n) * log(m * n))_ | _O(m * n)_       | Easy           |🔒| |
| 1285 | [Find the Start and End Number of Continuous Ranges](./problems/1285-find-the-start-and-end-number-of-continuous-ranges.md) | [MySQL](./MySQL/find-the-start-and-end-number-of-continuous-ranges.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1294 | [Weather Type in Each Country](./problems/1294-weather-type-in-each-country.md) | [MySQL](./MySQL/weather-type-in-each-country.sql) | _O(m + n)_ | _O(n)_       | Easy           |🔒| |
| 1303 | [Find the Team Size](./problems/1303-find-the-team-size.md) | [MySQL](./MySQL/find-the-team-size.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1321 | [Restaurant Growth](./problems/1321-restaurant-growth.md) | [MySQL](./MySQL/restaurant-growth.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒| |
| 1322 | [Ads Performance](./problems/1322-ads-performance.md) | [MySQL](./MySQL/ads-performance.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒| |
| 1327 | [List the Products Ordered in a Period](./problems/1327-list-the-products-ordered-in-a-period.md) | [MySQL](./MySQL/list-the-products-ordered-in-a-period.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1336 | [Number of Transactions per Visit](./problems/1336-number-of-transactions-per-visit.md) | [MySQL](./MySQL/number-of-transactions-per-visit.sql) | _O(m + n)_ | _O(m + n)_       | Medium           |🔒| |
| 1341 | [Movie Rating](./problems/1341-movie-rating.md) | [MySQL](./MySQL/movie-rating.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒| |
| 1355 | [Activity Participants](./problems/1355-activity-participants.md) | [MySQL](./MySQL/activity-participants.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1364 | [Number of Trusted Contacts of a Customer](./problems/1364-number-of-trusted-contacts-of-a-customer.md) | [MySQL](./MySQL/number-of-trusted-contacts-of-a-customer.sql) | _O(n + m + l + nlogn)_ | _O(n + m + l)_       | Medium           |🔒| |
| 1369 | [Get the Second Most Recent Activity](./problems/1369-get-the-second-most-recent-activity.md) | [MySQL](./MySQL/get-the-second-most-recent-activity.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒| |
| 1378 | [Replace Employee ID With The Unique Identifier](./problems/1378-replace-employee-id-with-the-unique-identifier.md) | [MySQL](./MySQL/replace-employee-id-with-the-unique-identifier.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1384 | [Total Sales Amount by Year](./problems/1384-total-sales-amount-by-year.md) | [MySQL](./MySQL/total-sales-amount-by-year.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒| |
| 1393 | [Capital Gain/Loss](./problems/1393-capital-gainloss.md) | [MySQL](./MySQL/capital-gainloss.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1398 | [Customers Who Bought Products A and B but Not C](./problems/1398-customers-who-bought-products-a-and-b-but-not-c.md) | [MySQL](./MySQL/customers-who-bought-products-a-and-b-but-not-c.sql) | _O(m + n)_ | _O(m + n)_       | Medium           |🔒| |
| 1407 | [Top Travellers](./problems/1407-top-travellers.md) | [MySQL](./MySQL/top-travellers.sql) | _O(m + nlogn)_ | _O(m + n)_       | Easy           |🔒| |
| 1412 | [Find the Quiet Students in All Exams](./problems/1412-find-the-quiet-students-in-all-exams.md) | [MySQL](./MySQL/find-the-quiet-students-in-all-exams.sql) | _O(m + nlogn)_ | _O(m + n)_       | Hard           |🔒| |
| 1421 | [NPV Queries](./problems/1421-npv-queries.md) | [MySQL](./MySQL/npv-queries.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1435 | [Create a Session Bar Chart](./problems/1435-create-a-session-bar-chart.md) | [MySQL](./MySQL/create-a-session-bar-chart.sql) | _O(n)_ | _O(1)_       | Easy           |🔒| |
| 1440 | [Evaluate Boolean Expression](./problems/1440-evaluate-boolean-expression.md) | [MySQL](./MySQL/evaluate-boolean-expression.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1445 | [Apples & Oranges](./problems/1445-apples-oranges.md) | [MySQL](./MySQL/apples-oranges.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1454 | [Active Users](./problems/1454-active-users.md) | [MySQL](./MySQL/active-users.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒| |
| 1459 | [Rectangles Area](./problems/1459-rectangles-area.md) | [MySQL](./MySQL/rectangles-area.sql) | _O(n^2)_ | _O(n^2)_       | Medium           |🔒| |
| 1468 | [Calculate Salaries](./problems/1468-calculate-salaries.md) | [MySQL](./MySQL/calculate-salaries.sql) | _O(m + n)_ | _O(m + n)_       | Easy           |🔒| |
| 1479 | [Sales by Day of the Week](./problems/1479-sales-by-day-of-the-week.md) | [MySQL](./MySQL/sales-by-day-of-the-week.sql) | _O(m + n)_ | _O(n)_       | Hard           |🔒| |
| 1484 | [Group Sold Products By The Date](./problems/1484-group-sold-products-by-the-date.md) | [MySQL](./MySQL/group-sold-products-by-the-date.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒| |
| 1501 | [Countries You Can Safely Invest In](./problems/1501-countries-you-can-safely-invest-in.md) | [MySQL](./MySQL/countries-you-can-safely-invest-in.sql) | _O(n)_ | _O(n)_       | Medium           |🔒| |
| 1511 | [Customer Order Frequency](./problems/1511-customer-order-frequency.md) | [MySQL](./MySQL/customer-order-frequency.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| |
| 1517 | [Find Users With Valid E-Mails](./problems/1517-find-users-with-valid-e-mails.md) | [MySQL](./MySQL/find-users-with-valid-e-mails.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| Regex |
| 1527 | [Patients With a Condition](./problems/1527-patients-with-a-condition.md) | [MySQL](./MySQL/patients-with-a-condition.sql) | _O(n)_ | _O(n)_       | Easy           |🔒| Regex |
| 1532 | [The Most Recent Three Orders](./problems/1532-the-most-recent-three-orders.md) | [MySQL](./MySQL/the-most-recent-three-orders.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 1543 | [Fix Product Name Format](./problems/1543-fix-product-name-format.md) | [MySQL](./MySQL/fix-product-name-format.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 1549 | [The Most Recent Orders for Each Product](./problems/1549-the-most-recent-orders-for-each-product.md) | [MySQL](./MySQL/the-most-recent-orders-for-each-product.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 1555 | [Bank Account Summary](./problems/1555-bank-account-summary.md) | [MySQL](./MySQL/bank-account-summary.sql) | _O(m + n)_ | _O(m + n)_       | Medium           |🔒||
| 1571 | [Warehouse Manager](./problems/1571-warehouse-manager.md) | [MySQL](./MySQL/warehouse-manager.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 1581 | [Customer Who Visited but Did Not Make Any Transactions](./problems/1581-customer-who-visited-but-did-not-make-any-transactions.md) | [MySQL](./MySQL/customer-who-visited-but-did-not-make-any-transactions.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1587 | [Bank Account Summary II](./problems/1587-bank-account-summary-ii.md) | [MySQL](./MySQL/bank-account-summary-ii.sql) | _O(m + n)_ | _O(m + n)_       | Easy           |🔒||
| 1596 | [The Most Frequently Ordered Products for Each Customer](./problems/1596-the-most-frequently-ordered-products-for-each-customer.md) | [MySQL](./MySQL/the-most-frequently-ordered-products-for-each-customer.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 1607 | [Sellers With No Sales](./problems/1607-sellers-with-no-sales.md) | [MySQL](./MySQL/sellers-with-no-sales.sql) | _O(nlogm)_ | _O(n + m)_       | Medium           |🔒||
| 1613 | [Find the Missing IDs](./problems/1613-find-the-missing-ids.md) | [MySQL](./MySQL/find-the-missing-ids.sql) | _O(n^2)_ | _O(n)_       | Medium           |🔒||
| 1623 | [All Valid Triplets That Can Represent a Country](./problems/1623-all-valid-triplets-that-can-represent-a-country.md) | [MySQL](./MySQL/all-valid-triplets-that-can-represent-a-country.sql) | _O(n^3)_ | _O(n^3)_       | Easy           |🔒||
| 1633 | [Percentage of Users Attended a Contest](./problems/1633-percentage-of-users-attended-a-contest.md) | [MySQL](./MySQL/percentage-of-users-attended-a-contest.sql) | _O(m + nlogn)_ | _O(n)_       | Easy           |🔒||
| 1635 | [Hopper Company Queries I](./problems/1635-hopper-company-queries-i.md) | [MySQL](./MySQL/hopper-company-queries-i.sql) | _O(d + r + tlogt)_ | _O(d + r + t)_       | Hard           |🔒||
| 1645 | [Hopper Company Queries II](./problems/1645-hopper-company-queries-ii.md) | [MySQL](./MySQL/hopper-company-queries-ii.sql) | _O(d + r + tlogt)_ | _O(d + r + t)_       | Hard           |🔒||
| 1651 | [Hopper Company Queries III](./problems/1651-hopper-company-queries-iii.md) | [MySQL](./MySQL/hopper-company-queries-iii.sql) | _O(d + r + tlogt)_ | _O(d + r + t)_       | Hard           |🔒||
| 1661 | [Average Time of Process per Machine](./problems/1661-average-time-of-process-per-machine.md) | [MySQL](./MySQL/average-time-of-process-per-machine.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1667 | [Fix Names in a Table](./problems/1667-fix-names-in-a-table.md) | [MySQL](./MySQL/fix-names-in-a-table.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 1677 | [Product's Worth Over Invoices](./problems/1677-products-worth-over-invoices.md) | [MySQL](./MySQL/products-worth-over-invoices.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 1683 | [Invalid Tweets](./problems/1683-invalid-tweets.md) | [MySQL](./MySQL/invalid-tweets.sql) | _O(n * l)_ | _O(n * l)_       | Easy           |🔒||
| 1693 | [Daily Leads and Partners](./problems/1693-daily-leads-and-partners.md) | [MySQL](./MySQL/daily-leads-and-partners.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1699 | [Number of Calls Between Two Persons](./problems/1699-number-of-calls-between-two-persons.md) | [MySQL](./MySQL/number-of-calls-between-two-persons.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 1709 | [Biggest Window Between Visits](./problems/1709-biggest-window-between-visits.md) | [MySQL](./MySQL/biggest-window-between-visits.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 1715 | [Count Apples and Oranges](./problems/1715-count-apples-and-oranges.md) | [MySQL](./MySQL/count-apples-and-oranges.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 1729 | [Find Followers Count](./problems/1729-find-followers-count.md) | [MySQL](./MySQL/find-followers-count.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 1731 | [The Number of Employees Which Report to Each Employee](./problems/1731-the-number-of-employees-which-report-to-each-employee.md) | [MySQL](./MySQL/the-number-of-employees-which-report-to-each-employee.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 1741 | [Find Total Time Spent by Each Employee](./problems/1741-find-total-time-spent-by-each-employee.md) | [MySQL](./MySQL/find-total-time-spent-by-each-employee.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 1747 | [Leetflex Banned Accounts](./problems/1747-leetflex-banned-accounts.md) | [MySQL](./MySQL/leetflex-banned-accounts.sql) | _O(n^2)_ | _O(n)_       | Medium           |🔒||
| 1757 | [Recyclable and Low Fat Products](./problems/1757-recyclable-and-low-fat-products.md) | [MySQL](./MySQL/recyclable-and-low-fat-products.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1767 | [Find the Subtasks That Did Not Execute](./problems/1767-find-the-subtasks-that-did-not-execute.md) | [MySQL](./MySQL/find-the-subtasks-that-did-not-execute.sql) | _O(n * c)_ | _O(n * c)_       | Hard           |🔒||
| 1777 | [Product's Price for Each Store](./problems/1777-products-price-for-each-store.md) | [MySQL](./MySQL/products-price-for-each-store.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1783 | [Grand Slam Titles](./problems/1783-grand-slam-titles.md) | [MySQL](./MySQL/grand-slam-titles.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 1795 | [Rearrange Products Table](./problems/1795-rearrange-products-table.md) | [MySQL](./MySQL/rearrange-products-table.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1809 | [Ad-Free Sessions](./problems/1809-ad-free-sessions.md) | [MySQL](./MySQL/ad-free-sessions.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1811 | [Find Interview Candidates](./problems/1811-find-interview-candidates.md) | [MySQL](./MySQL/find-interview-candidates.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 1821 | [Find Customers With Positive Revenue this Year](./problems/1821-find-customers-with-positive-revenue-this-year.md) | [MySQL](./MySQL/find-customers-with-positive-revenue-this-year.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1831 | [Maximum Transaction Each Day](./problems/1831-maximum-transaction-each-day.md) | [MySQL](./MySQL/maximum-transaction-each-day.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 1841 | [League Statistics](./problems/1841-league-statistics.md) | [MySQL](./MySQL/league-statistics.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 1843 | [Suspicious Bank Accounts](./problems/1843-suspicious-bank-accounts.md) | [MySQL](./MySQL/suspicious-bank-accounts.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 1853 | [Convert Date Format](./problems/1853-convert-date-format.md) | [MySQL](./MySQL/convert-date-format.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1867 | [Orders With Maximum Quantity Above Average](./problems/1867-orders-with-maximum-quantity-above-average.md) | [MySQL](./MySQL/orders-with-maximum-quantity-above-average.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1873 | [Calculate Special Bonus](./problems/1873-calculate-special-bonus.md) | [MySQL](./MySQL/calculate-special-bonus.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1890 | [The Latest Login in 2020](./problems/1890-the-latest-login-in-2020.md) | [MySQL](./MySQL/the-latest-login-in-2020.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 1892 | [Page Recommendations II](./problems/1892-page-recommendations-ii.md) | [MySQL](./MySQL/page-recommendations-ii.sql) | _O(n * m)_ | _O(n * m)_       | Hard           |🔒||
| 1917 | [Leetcodify Friends Recommendations](./problems/1917-leetcodify-friends-recommendations.md) | [MySQL](./MySQL/leetcodify-friends-recommendations.sql) | _O(n^2)_ | _O(n^2)_       | Hard           |🔒||
| 1919 | [Leetcodify Similar Friends](./problems/1919-leetcodify-similar-friends.md) | [MySQL](./MySQL/leetcodify-similar-friends.sql) | _O(n * l)_ | _O(n * l)_       | Hard           |🔒||
| 1934 | [Confirmation Rate](./problems/1934-confirmation-rate.md) | [MySQL](./MySQL/confirmation-rate.sql) | _O(n + m)_ | _O(n + m)_       | Medium           |🔒||
| 1939 | [Users That Actively Request Confirmation Messages](./problems/1939-users-that-actively-request-confirmation-messages.md) | [MySQL](./MySQL/users-that-actively-request-confirmation-messages.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 1949 | [Strong Friendship](./problems/1949-strong-friendship.md) | [MySQL](./MySQL/strong-friendship.sql) | _O(n^3)_ | _O(n^2)_       | Medium           |🔒||
| 1951 | [All the Pairs With the Maximum Number of Common Followers](./problems/1951-all-the-pairs-with-the-maximum-number-of-common-followers.md) | [MySQL](./MySQL/all-the-pairs-with-the-maximum-number-of-common-followers.sql) | _O(n^3)_ | _O(n^2)_       | Medium           |🔒||
| 1965 | [Employees With Missing Information](./problems/1965-employees-with-missing-information.md) | [MySQL](./MySQL/employees-with-missing-information.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 1972 | [First and Last Call On the Same Day](./problems/1972-first-and-last-call-on-the-same-day.md) | [MySQL](./MySQL/first-and-last-call-on-the-same-day.sql) | _O(n)_ | _O(n)_       | Hard           |🔒||
| 1978 | [Employees Whose Manager Left the Company](./problems/1978-employees-whose-manager-left-the-company.md) | [MySQL](./MySQL/employees-whose-manager-left-the-company.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 1988 | [Find Cutoff Score for Each School](./problems/1988-find-cutoff-score-for-each-schooly.md) | [MySQL](./MySQL/find-cutoff-score-for-each-school.sql) | _O(n * m)_ | _O(n * m)_       | Medium           |🔒||
| 1990 | [Count the Number of Experiments](./problems/1990-count-the-number-of-experiments.md) | [MySQL](./MySQL/count-the-number-of-experiments.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 2004 | [The Number of Seniors and Juniors to Join the Company](./problems/2004-the-number-of-seniors-and-juniors-to-join-the-company.md) | [MySQL](./MySQL/the-number-of-seniors-and-juniors-to-join-the-company.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 2010 | [The Number of Seniors and Juniors to Join the Company II](./problems/2010-the-number-of-seniors-and-juniors-to-join-the-company-ii.md) | [MySQL](./MySQL/the-number-of-seniors-and-juniors-to-join-the-company.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 2020 | [Number of Accounts That Did Not Stream](./problems/2020-number-of-accounts-that-did-not-stream.md) | [MySQL](./MySQL/number-of-accounts-that-did-not-stream.sql) | _O(m + n)_ | _O(m + n)_       | Medium           |🔒||
| 2026 | [Low-Quality Problems](./problems/2026-low-quality-problems.md) | [MySQL](./MySQL/low-quality-problems.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 2041 | [Accepted Candidates From the Interviews](./problems/2041-accepted-candidates-from-the-interviews.md) | [MySQL](./MySQL/accepted-candidates-from-the-interviews.sql) | _O(m + n)_ | _O(m + n)_       | Medium           |🔒||
| 2051 | [The Category of Each Member in the Store](./problems/2051-the-category-of-each-member-in-the-store.md) | [MySQL](./MySQL/the-category-of-each-member-in-the-store.sql) | _O(m + n)_ | _O(m + n)_       | Medium           |🔒||
| 2066 | [Account Balance](./problems/2066-account-balance.md) | [MySQL](./MySQL/account-balance.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2072 | [The Winner University](./problems/2072-the-winner-university.md) | [MySQL](./MySQL/the-winner-university.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 2082 | [The Number of Rich Customers](./problems/2082-the-number-of-rich-customers.md) | [MySQL](./MySQL/the-number-of-rich-customers.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 2084 | [Drop Type 1 Orders for Customers With Type 0 Orders](./problems/2084-drop-type-1-orders-for-customers-with-type-0-orders.md) | [MySQL](./MySQL/drop-type-1-orders-for-customers-with-type-0-orders.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2112 | [The Airport With the Most Traffic](./problems/2112-the-airport-with-the-most-traffic.md) | [MySQL](./MySQL/the-airport-with-the-most-traffic.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 2118 | [Build the Equation](./problems/2118-build-the-equation.md) | [MySQL](./MySQL/build-the-equation.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 2142 | [The Number of Passengers in Each Bus I](./problems/2142-the-number-of-passengers-in-each-bus-i.md) | [MySQL](./MySQL/the-number-of-passengers-in-each-bus-i.sql) | _O(p * b + blogb)_ | _O(p * b)_       | Medium           |🔒||
| 2153 | [The Number of Passengers in Each Bus II](./problems/2153-the-number-of-passengers-in-each-bus-ii.md) | [MySQL](./MySQL/the-number-of-passengers-in-each-bus-ii.sql) | _O(p * b + blogb)_ | _O(p * b)_       | Hard           |🔒||
| 2159 | [Order Two Columns Independently](./problems/2159-order-two-columns-independently.md) | [MySQL](./MySQL/order-two-columns-independently.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2173 | [Longest Winning Streak](./problems/2173-longest-winning-streak.md) | [MySQL](./MySQL/longest-winning-streak.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 2199 | [Finding the Topic of Each Post](./problems/2199-finding-the-topic-of-each-post.md) | [MySQL](./MySQL/finding-the-topic-of-each-post.sql) | _O(n * mlogm)_ | _O(n * m)_       | Hard           |🔒||
| 2205 | [The Number of Users That Are Eligible for Discount](./problems/2205-the-number-of-users-that-are-eligible-for-discount.md) | [MySQL](./MySQL/the-number-of-users-that-are-eligible-for-discount.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 2228 | [Users With Two Purchases Within Seven Days](./problems/2228-users-with-two-purchases-within-seven-days.md) | [MySQL](./MySQL/users-with-two-purchases-within-seven-days.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2230 | [The Users That Are Eligible for Discount](./problems/2230-the-users-that-are-eligible-for-discount.md) | [MySQL](./MySQL/the-users-that-are-eligible-for-discount.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 2238 | [Number of Times a Driver Was a Passenger](./problems/2238-number-of-times-a-driver-was-a-passenger.md) | [MySQL](./MySQL/number-of-times-a-driver-was-a-passenger.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 2252 | [Dynamic Pivoting of a Table](./problems/2252-dynamic-pivoting-of-a-table.md) | [MySQL](./MySQL/dynamic-pivoting-of-a-table.sql) | _O(n * m)_ | _O(n * m)_       | Hard           |🔒||
| 2253 | [Dynamic Unpivoting of a Table](./problems/2253-dynamic-unpivoting-of-a-table.md) | [MySQL](./MySQL/dynamic-unpivoting-of-a-table.sql) | _O(n * m)_ | _O(n * m)_       | Hard           |🔒||
| 2292 | [Products With Three or More Orders in Two Consecutive Years](./problems/2292-products-with-three-or-more-orders-in-two-consecutive-years.md) | [MySQL](./MySQL/products-with-three-or-more-orders-in-two-consecutive-years.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2298 | [Tasks Count in the Weekend](./problems/2298-tasks-count-in-the-weekend.md) | [MySQL](./MySQL/tasks-count-in-the-weekend.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 2308 | [Arrange Table by Gender](./problems/2308-arrange-table-by-gender.md) | [MySQL](./MySQL/arrange-table-by-gender.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2314 | [The First Day of the Maximum Recorded Degree in Each City](./problems/2314-the-first-day-of-the-maximum-recorded-degree-in-each-city.md) | [MySQL](./MySQL/the-first-day-of-the-maximum-recorded-degree-in-each-city.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2324 | [Product Sales Analysis IV](./problems/2324-product-sales-analysis-iv.md) | [MySQL](./MySQL/product-sales-analysis-iv.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2329 | [Product Sales Analysis V](./problems/2329-product-sales-analysis-v.md) | [MySQL](./MySQL/product-sales-analysis-v.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2339 | [All the Matches of the League](./problems/2339-all-the-matches-of-the-league.md) | [MySQL](./MySQL/all-the-matches-of-the-league.sql) | _O(n^2)_ | _O(n^2)_       | Easy           |🔒||
| 2356 | [Number of Unique Subjects Taught by Each Teacher](./problems/2356-number-of-unique-subjects-taught-by-each-teacher.md) | [MySQL](./MySQL/number-of-unique-subjects-taught-by-each-teacher.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 2362 | [Generate the Invoice](./problems/2362-generate-the-invoice.md) | [MySQL](./MySQL/generate-the-invoice.sql) | _O(m + nlogn)_ | _O(n + m)_       | Hard           |🔒||
| 2372 | [Calculate the Influence of Each Salesperson](./problems/2372-calculate-the-influence-of-each-salesperson.md) | [MySQL](./MySQL/calculate-the-influence-of-each-salesperson.sql) | _O(sp + c + s)_ | _O(sp + c + s)_       | Medium           |🔒||
| 2377 | [Sort the Olympic Table](./problems/2377-sort-the-olympic-table.md) | [MySQL](./MySQL/sort-the-olympic-table.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 2388 | [Change Null Values in a Table to the Previous Value](./problems/2388-change-null-values-in-a-table-to-the-previous-value.md) | [MySQL](./MySQL/change-null-values-in-a-table-to-the-previous-value.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2394 | [Employees With Deductions](./problems/2394-employees-with-deductions.md) | [MySQL](./MySQL/employees-with-deductions.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 2474 | [Customers With Strictly Increasing Purchases](./problems/2474-customers-with-strictly-increasing-purchases.md) | [MySQL](./MySQL/customers-with-strictly-increasing-purchases.sql) | _O(n)_ | _O(n)_       | Hard           |🔒||
| 2480 | [Form a Chemical Bond](./problems/2480-form-a-chemical-bond.md) | [MySQL](./MySQL/form-a-chemical-bond.sql) | _O(n^2)_ | _O(n)_       | Easy           |🔒||
| 2494 | [Merge Overlapping Events in the Same Hall](./problems/2494-merge-overlapping-events-in-the-same-hall.md) | [MySQL](./MySQL/merge-overlapping-events-in-the-same-hall.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 2504 | [Concatenate the Name and the Profession](./problems/2504-concatenate-the-name-and-the-profession.md) | [MySQL](./MySQL/concatenate-the-name-and-the-profession.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 2668 | [Find Latest Salaries](./problems/2668-find-latest-salaries.md) | [MySQL](./MySQL/find-latest-salaries.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 2686 | [Immediate Food Delivery III](./problems/2686-immediate-food-delivery-iii.md) | [MySQL](./MySQL/immediate-food-delivery-iii.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2687 | [Bikes Last Time Used](./problems/2687-bikes-last-time-used.md) | [MySQL](./MySQL/bikes-last-time-used.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 2688 | [Find Active Users](./problems/2688-find-active-users.md) | [MySQL](./MySQL/find-active-users.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2701 | [Consecutive Transactions with Increasing Amounts](./problems/2701-consecutive-transactions-with-increasing-amounts.md) | [MySQL](./MySQL/consecutive-transactions-with-increasing-amounts.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 2720 | [Popularity Percentage](./problems/2720-popularity-percentage.md) | [MySQL](./MySQL/popularity-percentage.sql) | _O(n^2)_ | _O(n^2)_       | Hard           |🔒||
| 2738 | [Count Occurrences in Text](./problems/2738-count-occurrences-in-text.md) | [MySQL](./MySQL/count-occurrences-in-text.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 2752 | [Customers with Maximum Number of Transactions on Consecutive Days](./problems/2752-customers-with-maximum-number-of-transactions-on-consecutive-days.md) | [MySQL](./MySQL/customers-with-maximum-number-of-transactions-on-consecutive-days.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 2783 | [Flight Occupancy and Waitlist Analysis](./problems/2783-flight-occupancy-and-waitlist-analysis.md) | [MySQL](./MySQL/flight-occupancy-and-waitlist-analysis.sql) | _O(n * m + nlogn)_ | _O(n * m)_       | Medium           |🔒||
| 2793 | [Status of Flight Tickets](./problems/2793-status-of-flight-tickets.md) | [MySQL](./MySQL/status-of-flight-tickets.sql) | _O(nlogn + m)_ | _O(n + m)_       | Hard           |🔒||
| 2820 | [Election Results](./problems/2820-election-results.md) | [MySQL](./MySQL/election-results.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2837 | [Total Traveled Distance](./problems/2837-election-results.md) | [MySQL](./MySQL/total-traveled-distance.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 2853 | [Highest Salaries Difference](./problems/2853-highest-salaries-difference.md) | [MySQL](./MySQL/highest-salaries-difference.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 2854 | [Rolling Average Steps](./problems/2854-rolling-average-steps.md) | [MySQL](./MySQL/rolling-average-steps.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2893 | [Calculate Orders Within Each Interval](./problems/2893-calculate-orders-within-each-interval.md) | [MySQL](./MySQL/calculate-orders-within-each-interval.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2922 | [Market Analysis III](./problems/2922-market-analysis-iii.md) | [MySQL](./MySQL/market-analysis-iii.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2978 | [Symmetric Coordinates](./problems/2978-symmetric-coordinates.md) | [MySQL](./MySQL/symmetric-coordinates.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2984 | [Find Peak Calling Hours for Each City](./problems/2984-find-peak-calling-hours-for-each-city.md) | [MySQL](./MySQL/find-peak-calling-hours-for-each-city.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2985 | [Calculate Compressed Mean](./problems/2985-calculate-compressed-mean.md) | [MySQL](./MySQL/calculate-compressed-mean.sql) | _O(n)_ | _O(n)_       | Easy           |🔒||
| 2986 | [Find Third Transaction](./problems/2986-find-third-transaction.md) | [MySQL](./MySQL/find-third-transaction.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2987 | [Find Expensive Cities](./problems/2987-find-expensive-cities.md) | [MySQL](./MySQL/find-expensive-cities.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 2989 | [Class Performance](./problems/2989-class-performance.md) | [MySQL](./MySQL/class-performance.sql) | _O(n)_ | _O(n)_       | Medium           |🔒||
| 2990 | [Loan Types](./problems/2990-loan-types.md) | [MySQL](./MySQL/loan-types.sql) | _O(nlogn)_ | _O(n)_       | Easy           |🔒||
| 2991 | [Top Three Wineries](./problems/2991-top-three-wineries.md) | [MySQL](./MySQL/top-three-wineries.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 2993 | [Friday Purchases I](./problems/2993-friday-purchases-i.md) | [MySQL](./MySQL/friday-purchases-i.sql) | _O(nlogn)_ | _O(n)_       | Medium           |🔒||
| 2994 | [Friday Purchases II](./problems/2994-friday-purchases-ii.md) | [MySQL](./MySQL/friday-purchases-ii.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
| 2995 | [Viewers Turned Streamers](./problems/2995-viewers-turned-streamers.md) | [MySQL](./MySQL/viewers-turned-streamers.sql) | _O(nlogn)_ | _O(n)_       | Hard           |🔒||
