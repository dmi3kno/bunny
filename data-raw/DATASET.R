## code to prepare `DATASET` dataset goes here

library(ggforce)
library(magick)
ggplot() +
  geom_regon(aes(x0 = 100, y0 = 100, sides = 6,
                 angle = pi/2, r = 100), color="#1a181f", fill="#f8f2f4", size=3) +
  coord_fixed()+
  theme_void()

ggsave("data-raw/tryit.png")

p <- image_read("data-raw/magic-hat.png") %>%
  image_scale("15%")
ii_p <- image_info(p)

b <- image_read("data-raw/tryit.png") %>% image_trim() %>%
  image_transparent("white")
ii_b <- image_info(b)

image_composite(b, p,
                offset = geometry_point(ii_b$width/2-ii_p$width/2,
                                        ii_b$height/2-ii_p$height/2-180)) %>%
  image_annotate("bunny", font="Aller", size=200, weight = 700,
                 location = geometry_point(0,
                                           ii_b$height/2-ii_p$height/2-100),
                 gravity = "Center", color = "#1a181f") %>%
  image_scale("1200x1200") %>%
  image_write("data-raw/bunny_hex.png", density = 600)



