
# check that parse_geometry is working
expect_equal(bunny:::parse_geometry("100x12"),
             setNames(c(100, 12, NA_real_, NA_real_),
                      c("width", "height", "x_off", "y_off"))
)

expect_equal(bunny:::parse_geometry("+14+12"),
             setNames(c(NA_real_, NA_real_, 14, 12),
                      c("width", "height", "x_off", "y_off"))
)


expect_equal(bunny:::parse_geometry("-63+14"),
             setNames(c(NA_real_, NA_real_, -63, 14),
                      c("width", "height", "x_off", "y_off"))
)

expect_equal(bunny:::parse_geometry("-63-14"),
             setNames(c(NA_real_, NA_real_, -63, -14),
                      c("width", "height", "x_off", "y_off"))
)


expect_equal(bunny:::parse_geometry("20"),
             setNames(c(20, NA_real_, NA_real_, NA_real_),
                      c("width", "height", "x_off", "y_off"))
)

expect_equal(bunny:::parse_geometry("x40"),
             setNames(c(NA_real_, 40, NA_real_, NA_real_),
                      c("width", "height", "x_off", "y_off"))
)

