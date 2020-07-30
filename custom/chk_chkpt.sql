
SELECT cat.checkpoint_label     c_chkpt_selected,
       vl.meaning               c_chkpt_desc
  FROM n_view_lookups               vl,
       n_checkpoint_activation_temp cat
WHERE vl.lookup_type = 'INSTALL4_CHECKPOINT'
   AND vl.lookup_code = cat.checkpoint_label
   AND rownum = 1;
