create database hackathong_02;
use hackathong_02;


create table Customers
(
    customer_id varchar(10) primary key,
    full_name   varchar(100) not null,
    phone       varchar(15)  not null unique,
    address     varchar(200) not null
);


create table Insuranceagents
(
    agent_id            varchar(10) primary key,
    full_name           varchar(100) not null,
    region              varchar(50)  not null,
    years_of_experience int check (years_of_experience >= 0),
    commission_rate     decimal(5, 2) check (commission_rate >= 0)
);


create table Policies
(
    policy_id   int auto_increment primary key,
    customer_id varchar(10),
    agent_id    varchar(10),
    start_date  timestamp not null,
    end_date    timestamp not null,
    status      enum ('Active','Expired','Cancelled'),
    foreign key (customer_id) references customers (customer_id),
    foreign key (agent_id) references insuranceagents (agent_id)
);


create table Claimpayments
(
    payment_id     int auto_increment primary key,
    policy_id      int,
    payment_method varchar(50) not null,
    payment_date   timestamp default current_timestamp,
    amount         decimal(15, 2) check (amount >= 0),
    foreign key (policy_id) references policies (policy_id)
);


insert into Customers
values ('C001', 'Nguyen Van An', '0912345678', 'HaNoi, VietNam'),
       ('C002', 'Tran Thi Binh', '0923456789', 'Ho Chi Minh, VietNam'),
       ('C003', 'Le Minh chau', '0934567890', 'Da Nang, VietNam'),
       ('C004', 'Pham Hoang Duc', '0945678901', 'Can Tho, VietNam'),
       ('C005', 'Vu Thi Hoa', '0956789012', 'Hai Phong, VietNam');

insert into Insuranceagents
values ('A001', 'Nguyen Van Minh', 'Mien Bac', 10, 5.50),
       ('A002', 'Tran Thi Lan', 'Mien Nam', 15, 7.00),
       ('A003', 'Le Hoang Nam', 'Mien Trung', 8, 4.50),
       ('A004', 'Pham Quang Huy', 'Mien Tay', 20, 8.00),
       ('A005', 'Vu Thi Mai', 'Mien Bac', 5, 3.50);

insert into Policies (customer_id, agent_id, start_date, end_date, status)
values ('C001', 'A001', '2024-01-01 08:00:00', '2025-01-01 08:00:00', 'Active'),
       ('C002', 'A002', '2024-02-01 09:30:00', '2025-02-01 09:30:00', 'Expired'),
       ('C003', 'A003', '2023-03-02 10:00:00', '2024-03-02 10:00:00', 'Cancelled'),
       ('C004', 'A004', '2024-05-02 14:00:00', '2025-05-02 14:00:00', 'Active'),
       ('C005', 'A005', '2024-06-03 15:30:00', '2025-06-03 15:30:00', 'Cancelled');

insert into Claimpayments (policy_id, payment_method, payment_date, amount)
values (1, 'Bank Transfer', '2024-05-01 08:45:00', 5000000),
       (2, 'Bank Transfer', '2024-06-01 10:00:00', 7500000),
       (4, 'Cash', '2024-08-02 15:00:00', 2000000),
       (1, 'Bank Transfer', '2024-09-04 11:00:00', 3000000),
       (3, 'Credit Card', '2023-10-05 14:00:00', 1500000);


-- 3. Viết câu lệnh thay đổi địa chỉ của khách hàng có customer_id = 'C002' thành "District 1, Ho Chi Minh City".
update Customers
set address = 'District 1, Ho Chi Minh City'
where customer_id = 'C002';

-- 4. Thay đổi trạng thái nhân viên:. Nhân viên có mã A001 đạt thành tích tốt, hãy tăng years_of_experience thêm 2 năm và tăng commission_rate thêm 1.5%.
update InsuranceAgents
set years_of_experience = years_of_experience + 2,
    commission_rate=commission_rate + 1.5
where agent_id = 'A001';

-- 5. Xóa dữ liệu có điều kiện. Viết câu lệnh xóa tất cả các hợp đồng trong bảng Policies có trạng thái là "Cancelled" và ngày bắt đầu trước ngày "2024-06-15".
delete
from Policies
where status = 'Cancelled'
  and start_date < '2024-06-15';

-- 6. Liệt kê danh sách các nhân viên bảo hiểm gồm: agent_id, full_name, region có số năm kinh nghiệm (years_of_experience) trên 8 năm.
select agent_id,
       full_name,
       region
from InsuranceAgents
where years_of_experience > 8;

-- 7. Lấy thông tin customer_id, full_name, phone của những khách hàng có tên chứa từ khóa "Nguyen".
select customer_id, full_name, phone
from Customers
where full_name like '%Nguyen%';

-- 8. Hiển thị danh sách tất cả các hợp đồng gồm: policy_id, start_date, status, sắp xếp theo ngày bắt đầu (start_date) giảm dần.
select policy_id, start_date, status
from Policies
order by start_date desc;

-- 9. Lấy thông tin 3 bản ghi đầu tiên trong bảng ClaimPayments có phương thức thanh toán là 'Bank Transfer'.
select *
from Claimpayments
where payment_method = 'bank transfer'
limit 3;

-- 10. Hiển thị thông tin gồm mã nhân viên (agent_id) và tên nhân viên (full_name) từ bảng InsuranceAgents, bỏ qua 2 bản ghi đầu tiên và lấy 3 bản ghi tiếp theo (LIMIT và OFFSET).
select agent_id, full_name
from Insuranceagents
limit 3 offset 2;

-- 11. Hiển thị danh sách hợp đồng gồm: policy_id, customer_name (từ bảng Customers), agent_name (từ bảng InsuranceAgents) và status. Chỉ lấy những hợp đồng có trạng thái là 'Active'.
select p.policy_id,
       c.full_name as customer_name,
       a.full_name as agent_name,
       p.status
from Policies p
         join customers c on p.customer_id = c.customer_id
         join Insuranceagents a on p.agent_id = a.agent_id
where p.status = 'active';

-- 12. Liệt kê tất cả các nhân viên trong hệ thống gồm: agent_id, full_name và policy_id tương ứng. Kết quả phải bao gồm cả những nhân viên chưa từng ký hợp đồng nào (Sử dụng LEFT JOIN).
select a.agent_id, a.full_name, p.policy_id
from Insuranceagents a
         left join Policies p on a.agent_id = p.agent_id;

-- 13. Tính tổng tiền bồi thường (SUM(amount)) theo từng phương thức thanh toán (payment_method). Kết quả hiển thị 2 cột: payment_method và Total_Payout.
select payment_method,
       sum(amount) as total_payout
from Claimpayments
group by payment_method;

-- 14.Thống kê số lượng hợp đồng mà mỗi nhân viên đã ký. Hiển thị agent_id, full_name và Total_Policies. Chỉ hiện những nhân viên có từ 1 hợp đồng trở lên.
select a.agent_id,
       a.full_name,
       count(p.policy_id) as total_policies
from Insuranceagents a
         join Policies p on a.agent_id = p.agent_id
group by a.agent_id, a.full_name
having count(p.policy_id) >= 1;
-- 15. Lấy thông tin chi tiết các nhân viên (agent_id, full_name, commission_rate) có mức hoa hồng cao hơn mức hoa hồng trung bình của tất cả các nhân viên.
select agent_id, full_name, commission_rate
from insuranceagents
where commission_rate >
      (select avg(commission_rate) from insuranceagents);
-- 16. Hiển thị customer_id và full_name của những khách hàng đã từng có yêu cầu bồi thường (Claim) với số tiền lớn hơn 5.000.000 (Gợi ý: Dùng JOIN giữa Customers, Policiesvà ClaimPayments).


