-- West Auriga daily-check rounds taken on Capella's sheet (rolling handoff entry 49.4, SSORT 157, 5 Oct 2026).
-- Before SSORT 157 the Daily Checks panel could stay on Capella's sheet after West Auriga was picked.
-- The two sheets share no system names, so a reading's system says which sheet the crew was shown.
-- Run in SACRED DATA (New Query). One row per round: rounds with on_capella_sheet above 0 were taken on the wrong sheet.

SELECT [file], [date], [shift], [kind],
       COUNT(*) AS readings,
       SUM(CASE WHEN [system] IN ('bop_control_manifold_pressures','ccc_system_tensioner_skid','cmc_apv_hp_pump','diverter_panel_hpu','flowmeters_lamptest_alarms','marine_riser_tensioner_system','slip_joint_moonpool','stack_pressures','surface_diverter_pressures','tensioner_ring_panel') THEN 1 ELSE 0 END) AS on_capella_sheet,
       SUM(CASE WHEN [system] IN ('apvs_and_control_skid','bop_control_panel_readbacks','bop_hpu','ccc','choke_and_kill_manifold','diverter_functions','general','high_pressure_compressors','mixing_skid','moonpool','notes','riser_tension_panel_rig_floor','romar') THEN 1 ELSE 0 END) AS on_auriga_sheet
FROM dbo.rig_checks
WHERE rig = 'West Auriga'
GROUP BY [file], [date], [shift], [kind]
ORDER BY [date], [shift];

-- The one-line answer for the tools session:
SELECT COUNT(*) AS auriga_rounds,
       SUM(CASE WHEN on_capella_sheet > 0 THEN 1 ELSE 0 END) AS rounds_on_capella_sheet,
       MIN(CASE WHEN on_capella_sheet > 0 THEN [date] END) AS first_wrong, MAX(CASE WHEN on_capella_sheet > 0 THEN [date] END) AS last_wrong
FROM (SELECT [file], [date],
             SUM(CASE WHEN [system] IN ('bop_control_manifold_pressures','ccc_system_tensioner_skid','cmc_apv_hp_pump','diverter_panel_hpu','flowmeters_lamptest_alarms','marine_riser_tensioner_system','slip_joint_moonpool','stack_pressures','surface_diverter_pressures','tensioner_ring_panel') THEN 1 ELSE 0 END) AS on_capella_sheet
      FROM dbo.rig_checks WHERE rig = 'West Auriga' GROUP BY [file], [date]) r;
