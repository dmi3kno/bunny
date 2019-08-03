## code to prepare `DATASET` dataset goes here

library(ggforce)
library(magick)


ggplot() +
  geom_regon(aes(x0 = 100, y0 = 100, sides = 6,
                 angle = pi/2, r = 100), color="#1a181f", fill="#f8f2f4", size=2.5) +
  coord_fixed()+
  theme_void()

hex_file <- tempfile()

ggsave(hex_file)

b <- image_read(hex_file) %>% image_trim() %>%
  image_transparent("white")
ii_b <- image_info(b)

p <- image_read("data-raw/magic-hat.png") %>%
  image_scale("15%")
ii_p <- image_info(p)

img_hex <- image_composite(b, p,
                offset = geometry_point(ii_b$width/2-ii_p$width/2,
                                        ii_b$height/2-ii_p$height/2-180)) %>%
  image_annotate("bunny", font="Aller", size=250, weight = 600,
                 location = geometry_point(0,
                                           ii_b$height/2-ii_p$height/2-80),
                 gravity = "Center", color = "#1a181f")
img_hex %>%
  image_scale("1200x1200") %>%
  image_write("data-raw/bunny_hex.png", density = 600)

img_hex %>%
  image_scale("200x200") %>%
  image_write("man/figures/logo.png", density = 600)



