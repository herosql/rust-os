#![no_std]
#![no_main]

fn _strwrite(string: &str) {
    let mut p_strdst = 0xb8000 as *mut u8; // 指向显存的开始地址
    let color: u8 = 0x0F; // 设置颜色属性，例如白色前景色和黑色背景色

    for &byte in string.as_bytes() {
        unsafe {
            *p_strdst = byte;
            p_strdst = p_strdst.add(1);
            *p_strdst = color;
            p_strdst = p_strdst.add(1);
        }
    }
}

fn printf(fmt: &str) {
    _strwrite(fmt);
}

// 自定义的入口函数
#[no_mangle]
pub extern "C" fn _start() {
    // 在这里编写您的代码，例如：
    // 初始化硬件、显示"Hello, World!"等
    printf("Hello OS!");
}
