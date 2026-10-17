-- ============================================================================
-- NIÊN COFFEE (1990s) - DATABASE SCHEMA & TRIGGER TỰ ĐỘNG BẢO MẬT DỮ LIỆU
-- Cấu hình tương thích: Supabase / PostgreSQL 15+
-- ============================================================================

-- BẬT CÁC EXTENSION CẦN THIẾT
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. BẢNG THÀNH VIÊN SỔ NIÊN KỶ (MEMBERS)
CREATE TABLE IF NOT EXISTS public.members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone VARCHAR(20) UNIQUE NOT NULL,
    pin_hash VARCHAR(100) NOT NULL, -- Mã PIN 4 số bí mật
    full_name VARCHAR(100) DEFAULT 'Khách Quen Niên',
    tier VARCHAR(50) DEFAULT 'Người Mới Ghé (Sơ Ngộ)',
    points_balance INT DEFAULT 30, -- Tặng 30 điểm khởi đầu
    total_spent BIGINT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. BẢNG ĐƠN HÀNG GỌI MÓN THEO BÀN & MANG VỀ (ORDERS)
CREATE TABLE IF NOT EXISTS public.orders (
    id VARCHAR(50) PRIMARY KEY, -- Mã đơn: NIEN-B03-8923
    table_number VARCHAR(50) NOT NULL, -- Bàn 03, Bàn 05, Mang về...
    customer_name VARCHAR(100) DEFAULT 'Khách tại bàn',
    customer_phone VARCHAR(20),
    items JSONB NOT NULL, -- Mảng danh sách món, số lượng, ghi chú
    subtotal BIGINT NOT NULL,
    discount_amount BIGINT DEFAULT 0,
    voucher_code VARCHAR(50),
    total_amount BIGINT NOT NULL,
    points_earned INT DEFAULT 0,
    payment_method VARCHAR(50) DEFAULT 'VietQR',
    payment_status VARCHAR(50) DEFAULT 'PAID', -- PENDING | PAID | REFUNDED
    status VARCHAR(50) DEFAULT 'new', -- new | brewing | done | cancelled
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. BẢNG HÒM THƯ "LỜI THƯƠNG CHƯA NÓI" & BƯU THIẾP (POSTCARDS)
CREATE TABLE IF NOT EXISTS public.postcards (
    id BIGSERIAL PRIMARY KEY,
    sender_name VARCHAR(100) NOT NULL,
    sender_phone VARCHAR(20),
    recipient_name VARCHAR(100) NOT NULL,
    recipient_phone VARCHAR(20),
    recipient_address TEXT,
    content TEXT NOT NULL,
    pen_mode VARCHAR(20) DEFAULT 'ink', -- ink | type
    is_private_diary BOOLEAN DEFAULT FALSE,
    is_dispatched BOOLEAN DEFAULT FALSE, -- Nhân viên bưu cục đã gửi bưu điện
    tracking_code VARCHAR(50), -- Mã vận đơn bưu cục VNPost
    created_at TIMESTAMPTZ DEFAULT NOW(),
    dispatched_at TIMESTAMPTZ
);

-- 4. BẢNG BỨC TƯỜNG KÝ ỨC (STORIES)
CREATE TABLE IF NOT EXISTS public.stories (
    id BIGSERIAL PRIMARY KEY,
    author VARCHAR(100) NOT NULL,
    year VARCHAR(10) DEFAULT '1995',
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    image_url TEXT,
    likes_count INT DEFAULT 1,
    status VARCHAR(50) DEFAULT 'pending', -- pending | approved | rejected
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- TRIGGER TỰ ĐỘNG BẢO MẬT: TỰ HỦY ĐỊA CHỈ NGƯỜI NHẬN SAU KHI GỬI BƯU ĐIỆN
-- Đây là cam kết danh dự bảo vệ quyền riêng tư tuyệt đối cho khách hàng!
-- ============================================================================
CREATE OR REPLACE FUNCTION purge_postcard_privacy_info()
RETURNS TRIGGER AS $$
BEGIN
    -- Khi nhân viên bưu cục chuyển trạng thái is_dispatched thành TRUE:
    IF NEW.is_dispatched = TRUE AND OLD.is_dispatched = FALSE THEN
        NEW.recipient_address := '[ĐÃ XÓA VĨNH VIỄN - BẢO MẬT TUYỆT ĐỐI]';
        NEW.recipient_phone := '[ĐÃ XÓA]';
        NEW.dispatched_at := NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_purge_postcard_privacy
BEFORE UPDATE ON public.postcards
FOR EACH ROW
EXECUTE FUNCTION purge_postcard_privacy_info();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) - BẢO MẬT ĐA TẦNG CHO THÀNH VIÊN VÀ NHẬT KÝ
-- ============================================================================
ALTER TABLE public.members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.postcards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Công khai các bài viết đã duyệt
CREATE POLICY "Public Approved Stories" ON public.stories
    FOR SELECT USING (status = 'approved');

-- Cho phép khách gửi bài viết chờ duyệt
CREATE POLICY "Insert Story Pending" ON public.stories
    FOR INSERT WITH CHECK (status = 'pending');
