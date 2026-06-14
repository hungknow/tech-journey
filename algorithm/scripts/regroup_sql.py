#!/usr/bin/env python3
"""Regroup SQL problems into Join/Aggregate, Window/Rank, and Other by problem title/signature."""

import re
from pathlib import Path

# Problem numbers that belong to Window/Rank (RANK, ROW_NUMBER, LAG/LEAD, running sum/avg, "per X" ranking)
WINDOW_RANK = {
    178,  # Rank Scores
    185,  # Department Top Three Salaries (DENSE_RANK)
    569,  # Median Employee Salary (window for median)
    579,  # Find Cumulative Salary (running sum)
    603,  # Consecutive Available Seats (note: Window Function)
    618,  # Students Report By Geography (ROW_NUMBER for pivot)
    626,  # Exchange Seats (ROW_NUMBER)
    1097,  # Game Play Analysis V (retention/window)
    1107,  # New Users Daily Count (first login = ROW_NUMBER)
    1112,  # Highest Grade For Each Student (MAX/RANK per student)
    1132,  # Reported Posts II (window)
    1164,  # Product Price at a Given Date (ROW_NUMBER)
    1204,  # Last Person to Fit in the Elevator (running sum)
    1225,  # Report Contiguous Dates (gap-and-island)
    1285,  # Find the Start and End Number of Continuous Ranges (gap-and-island)
    1308,  # Running Total for Different Genders
    1321,  # Restaurant Growth (running avg)
    1336,  # Number of Transactions per Visit
    1341,  # Movie Rating (rank)
    1369,  # Get the Second Most Recent Activity (ROW_NUMBER)
    1384,  # Total Sales Amount by Year
    1393,  # Capital Gain/Loss (running sum by stock)
    1412,  # Find the Quiet Students (rank in exams)
    1454,  # Active Users (consecutive days)
    1532,  # The Most Recent Three Orders (ROW_NUMBER)
    1549,  # The Most Recent Orders for Each Product (ROW_NUMBER)
    1596,  # The Most Frequently Ordered Products for Each Customer (RANK)
    1709,  # Biggest Window Between Visits (LAG/LEAD)
    1831,  # Maximum Transaction Each Day (RANK)
    1843,  # Suspicious Bank Accounts (window)
    1972,  # First and Last Call On the Same Day (LAG/LEAD)
    2066,  # Account Balance (running sum)
    2173,  # Longest Winning Streak
    2175,  # The Change in Global Rankings
    2228,  # Users With Two Purchases Within Seven Days (LAG/LEAD)
    2292,  # Products With Three or More Orders in Two Consecutive Years
    2308,  # Arrange Table by Gender (ROW_NUMBER)
    2314,  # The First Day of the Maximum Recorded Degree in Each City
    2324,  # Product Sales Analysis IV (RANK)
    2329,  # Product Sales Analysis V
    2346,  # Compute the Rank as a Percentage
    2388,  # Change Null Values to the Previous Value (LAG)
    2474,  # Customers With Strictly Increasing Purchases
    2494,  # Merge Overlapping Events (window)
    2668,  # Find Latest Salaries (ROW_NUMBER per emp)
    2686,  # Immediate Food Delivery III
    2687,  # Bikes Last Time Used (MAX/ROW_NUMBER)
    2688,  # Find Active Users
    2701,  # Consecutive Transactions with Increasing Amounts
    2752,  # Customers with Maximum Number of Transactions on Consecutive Days
    2854,  # Rolling Average Steps
    2893,  # Calculate Orders Within Each Interval
    2922,  # Market Analysis III (RANK)
    2984,  # Find Peak Calling Hours for Each City
    2986,  # Find Third Transaction (ROW_NUMBER)
    2991,  # Top Three Wineries (RANK)
    2993,  # Friday Purchases I
    2994,  # Friday Purchases II
    2995,  # Viewers Turned Streamers
}

# Problem numbers that belong to Join/Aggregate (JOIN, GROUP BY, COUNT/SUM/AVG/MAX/MIN, HAVING)
JOIN_AGGREGATE = {
    175,  # Combine Two Tables
    176,  # Second Highest Salary
    177,  # Nth Highest Salary
    182,  # Duplicate Emails
    184,  # Department Highest Salary
    181,  # Employees Earning More Than Their Managers (self join)
    183,  # Customers Who Never Order
    511,  # Game Play Analysis I
    570,  # Managers with at Least 5 Direct Reports
    574,  # Winning Candidate
    577,  # Employee Bonus
    578,  # Get Highest Answer Rate Question
    580,  # Count Student Number in Departments
    584,  # Find Customer Referee
    586,  # Customer Placing the Largest Number of Orders
    595,  # Big Countries
    596,  # Classes More Than 5 Students
    597,  # Friend Requests I
    602,  # Friend Requests II
    607,  # Sales Person
    615,  # Average Salary: Departments VS Company
    619,  # Biggest Single Number
    1045,  # Customers Who Bought All Products
    1050,  # Actors and Directors Who Cooperated At Least Three Times
    1068, 1070,  # Product Sales Analysis I, III
    1069,  # Product Sales Analysis II
    1075, 1076, 1077,  # Project Employees I, II, III
    1082, 1083, 1084,  # Sales Analysis I, II, III
    1098,  # Unpopular Books
    1113,  # Reported Posts
    1126,  # Active Businesses
    1141, 1142,  # User Activity I, II
    1148, 1149,  # Article Views I, II
    1158, 1159,  # Market Analysis I, II
    1173, 1174,  # Immediate Food Delivery I, II
    1193,  # Monthly Transactions I (GROUP BY month)
    1211,  # Queries Quality and Percentage
    1241,  # Number of Comments per Post
    1251,  # Average Selling Price
    1303,  # Find the Team Size
    1322,  # Ads Performance
    1327,  # List the Products Ordered in a Period
    1350,  # Students With Invalid Departments
    1355,  # Activity Participants
    1378,  # Replace Employee ID
    1407,  # Top Travellers
    1484,  # Group Sold Products By The Date
    1565,  # Unique Orders and Customers Per Month
    1581,  # Customer Who Visited but Did Not Make Any Transactions
    1587,  # Bank Account Summary II
    1633,  # Percentage of Users Attended a Contest
    1661,  # Average Time of Process per Machine
    1729,  # Find Followers Count
    1731,  # The Number of Employees Which Report to Each Employee
    1741,  # Find Total Time Spent by Each Employee
    1757,  # Recyclable and Low Fat Products
    1821,  # Find Customers With Positive Revenue
    1875,  # Group Employees of the Same Salary
    1907,  # Count Salary Categories
    1965,  # Employees With Missing Information
    1978,  # Employees Whose Manager Left the Company
    1990,  # Count the Number of Experiments
    2072,  # The Winner University
    2082,  # The Number of Rich Customers
    2112,  # The Airport With the Most Traffic
    2356,  # Number of Unique Subjects Taught by Each Teacher
    2377,  # Sort the Olympic Table
    2394,  # Employees With Deductions
    2669,  # Count Artist Occurrences On Spotify Ranking List
    2853,  # Highest Salaries Difference
    2985,  # Calculate Compressed Mean
    2987,  # Find Expensive Cities
    2988,  # Manager of the Largest Department
    2989,  # Class Performance
    2990,  # Loan Types
}

# All remaining go to Other (UPDATE/DELETE, PIVOT, simple WHERE, complex logic, etc.)
# 0196 Delete Duplicate Emails, 0627 Swap Salary, 1179 Reformat Department Table, 1789 Primary Department
# 0180 Consecutive Numbers, 0197 Rising Temperature, 0262 Trips and Users, 0512 0534 0550 Game Play II III IV
# 0571 Find Median Given Frequency, 0585 Investments 2016, 0601 Human Traffic, 0608 Tree Node, 0610 0612 0613
# 0614 Second Degree Follower, 0620 Not Boring Movies, 1205 Monthly Transactions II, 1495 Friendly Movies
# ... and everything else not in WINDOW_RANK or JOIN_AGGREGATE


def extract_num(row: str) -> int:
    m = re.match(r"^\|\s*(\d+)\s*\|", row)
    return int(m.group(1)) if m else -1


def main():
    base = Path(__file__).resolve().parent.parent
    path = base / "sql.md"
    text = path.read_text(encoding="utf-8")

    lines = text.splitlines()
    header = lines[:6]  # ## SQL ... table header
    rows = []
    for line in lines[6:]:
        if re.match(r"^\|\s*\d+\s*\|", line):
            rows.append(line)
        elif line.strip() in ("---", ""):
            continue
        elif line.startswith("### ") or (line.startswith("|") and "Title" in line):
            continue
        else:
            continue

    join_rows = []
    window_rows = []
    other_rows = []
    for row in rows:
        num = extract_num(row)
        if num < 0:
            continue
        if num in WINDOW_RANK:
            window_rows.append((num, row))
        elif num in JOIN_AGGREGATE:
            join_rows.append((num, row))
        else:
            other_rows.append((num, row))

    join_rows.sort(key=lambda x: x[0])
    window_rows.sort(key=lambda x: x[0])
    other_rows.sort(key=lambda x: x[0])

    out = [
        "## SQL",
        "",
        "### 1. Join / Aggregate",
        "",
        "| # | Title | Solution | Time | Space | Difficulty | Tag | Note |",
        "|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|",
    ]
    for _, row in join_rows:
        out.append(row)
    out.extend([
        "",
        "---",
        "",
        "### 2. Window / Rank",
        "",
        "| # | Title | Solution | Time | Space | Difficulty | Tag | Note |",
        "|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|",
    ])
    for _, row in window_rows:
        out.append(row)
    out.extend([
        "",
        "---",
        "",
        "### 3. Other",
        "",
        "| # | Title | Solution | Time | Space | Difficulty | Tag | Note |",
        "|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|",
    ])
    for _, row in other_rows:
        out.append(row)
    out.append("")

    path.write_text("\n".join(out), encoding="utf-8")
    print(f"Join/Aggregate: {len(join_rows)}, Window/Rank: {len(window_rows)}, Other: {len(other_rows)}")


if __name__ == "__main__":
    main()
