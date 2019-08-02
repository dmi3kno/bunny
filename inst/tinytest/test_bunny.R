
# check that parse_geometry is working
expect_equal(bunny::geometry_parse("100x12"),
             matrix(c(100, 12, NA_real_, NA_real_),
                    nrow = 1, dimnames = list(NULL, c("width", "height", "x_off", "y_off")))
)

expect_equal(bunny::geometry_parse("+14+12"),
             matrix(c(NA_real_, NA_real_, 14, 12),
                    nrow = 1, dimnames = list(NULL,c("width", "height", "x_off", "y_off")))
)


expect_equal(bunny::geometry_parse("-63+14"),
             matrix(c(NA_real_, NA_real_, -63, 14),
                    nrow = 1, dimnames = list(NULL,c("width", "height", "x_off", "y_off")))
)

expect_equal(bunny::geometry_parse("-63-14"),
             matrix(c(NA_real_, NA_real_, -63, -14),
                    nrow = 1, dimnames = list(NULL,c("width", "height", "x_off", "y_off")))
)


expect_equal(bunny::geometry_parse("20"),
             matrix(c(20, NA_real_, NA_real_, NA_real_),
                    nrow = 1, dimnames = list(NULL,c("width", "height", "x_off", "y_off")))
)

expect_equal(bunny:::geometry_parse("x40"),
             matrix(c(NA_real_, 40, NA_real_, NA_real_),
                    nrow = 1, dimnames = list(NULL, c("width", "height", "x_off", "y_off")))
)

