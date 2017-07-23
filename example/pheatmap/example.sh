s-plot pheatmap -f heatmap_data.xls -d row -P heatmap_row_anno.xls -Q heatmap_col_anno.xls -o ./ -A 45 -e FALSE
Rscript heatmap_data.xls.pheatmap.r
