# setwd("/home/schmid/agora/poseidon-framework.github.io/version_table_figure")

library(ggplot2)
library(magrittr)

make_sorted_factor <- function(x, ...) {
  factor(x, levels = unique(stringr::str_sort(x, numeric = TRUE)), ...)
}

versions_raw <- readr::read_tsv("version_table.tsv")

versions <- versions_raw %>%
  dplyr::mutate(
    tool = factor(tool, levels = c("trident", "xerxes", "qjanno", "janno")),
    poseidonVersion = make_sorted_factor(poseidonVersion, ordered = TRUE),
    version = make_sorted_factor(version)
  )

versions_for_segments <- versions %>%
  dplyr::group_by(tool, version) %>%
  dplyr::summarise(
    minPoseidonVersion = min(poseidonVersion),
    maxPoseidonVersion = max(poseidonVersion),
  ) %>%
  dplyr::ungroup()

p <- ggplot() +
  facet_grid(rows = dplyr::vars(tool), scales = "free_y", space = "free_y", switch = "both") +
  geom_segment(
    data = versions_for_segments,
    mapping = aes(x = minPoseidonVersion, xend = maxPoseidonVersion, y = version, yend = version),
    color = "#1587D3",
    linewidth = 1.2
  ) +
  geom_point(
    data = versions,
    mapping = aes(x = poseidonVersion, y = version),
    color = "#1587D3",
    size = 3
  ) +  
  geom_point(
    data = versions,
    mapping = aes(x = poseidonVersion, y = version),
    color = "#283339",
    size = 1.5
  ) +
  scale_y_discrete(position = "right") +
  scale_x_discrete(position = "top") +
  theme(
    strip.text.y.left = element_text(angle = 0),
    axis.title.y = element_blank(),
    plot.background = element_rect(fill = "#283339"),
    #axis.text.y.right = element_text(hjust = 1),
    axis.text = element_text(color = "white", size = 10),
    axis.title = element_text(color = "white", size = 10),
    panel.background = element_rect(fill = "#283339"),
    panel.grid.major.y = element_line(linewidth = 0.1),
    panel.grid.minor.y = element_blank(),
    strip.background = element_rect(fill = NA, color = "white"),
    strip.text = element_text(color = "white", size = 10),
    text = element_text(family = "mono")
  ) +
  xlab("Poseidon Version")

ggsave(
  filename = "version_figure.png",
  plot = p,
  device = "png",
  scale = 4,
  units = "px",
  width = 150,
  height = 300,
  dpi = 150
)
  
