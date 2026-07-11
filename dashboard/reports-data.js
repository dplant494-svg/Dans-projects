window.DASHBOARD_DATA = {
  "generatedAt": "2026-07-11T06:00:00",
  "reportFolder": "sample-reports (demo data — run scripts\\Update-Dashboard.ps1 to use your real TSC REPORTS folder)",
  "reports": [
    {
      "file": "seadrill-report_West-Gemini_2026-07-09.json",
      "rig": "West Gemini",
      "type": "BWM Compliance",
      "discipline": "Well Control (WCEG)",
      "wce": "M. Reyes",
      "location": "Angola Block 17",
      "date": "2026-07-09",
      "dateEnd": "2026-07-10",
      "exportedAt": "2026-07-10T17:30:00.000Z",
      "modified": "2026-07-10T17:30:00",
      "tileCount": 2,
      "criticalTotal": 0,
      "criticalOpen": 0,
      "actionsTotal": 1,
      "actionsLeftWithRig": 1,
      "criticalItems": [],
      "actionItems": [
        {
          "desc": "Close out BWM checklist items 4 & 7",
          "sys": "BOP",
          "resp": "SSS",
          "target": "",
          "deadline": "2026-07-18",
          "leftWithRig": true
        }
      ]
    },
    {
      "file": "seadrill-report_West-Neptune_2026-07-06.json",
      "rig": "West Neptune",
      "type": "Operations Support",
      "discipline": "Well Control (WCEG)",
      "wce": "D. Plant",
      "location": "GoM — Shenandoah",
      "date": "2026-07-06",
      "dateEnd": "2026-07-08",
      "exportedAt": "2026-07-08T17:30:00.000Z",
      "modified": "2026-07-08T17:30:00",
      "tileCount": 3,
      "criticalTotal": 0,
      "criticalOpen": 0,
      "actionsTotal": 0,
      "actionsLeftWithRig": 0,
      "criticalItems": [],
      "actionItems": []
    },
    {
      "file": "seadrill-report_West-Tellus_2026-07-03.json",
      "rig": "West Tellus",
      "type": "NPT Support",
      "discipline": "Well Control (WCEG)",
      "wce": "M. Reyes",
      "location": "GoM — Kaskida",
      "date": "2026-07-03",
      "dateEnd": "2026-07-05",
      "exportedAt": "2026-07-05T17:30:00.000Z",
      "modified": "2026-07-05T17:30:00",
      "tileCount": 3,
      "criticalTotal": 1,
      "criticalOpen": 1,
      "actionsTotal": 1,
      "actionsLeftWithRig": 1,
      "criticalItems": [
        {
          "done": false,
          "equip": "Diverter Packer",
          "sfi": "312.02",
          "date": "2026-07-03",
          "issue": "Pressure test failed at 500 psi",
          "mit": "Packer replacement scheduled next trip out"
        }
      ],
      "actionItems": [
        {
          "desc": "Expedite diverter packer to rig",
          "sys": "Diverter",
          "resp": "Rig Mgr",
          "target": "",
          "deadline": "2026-07-12",
          "leftWithRig": true
        }
      ]
    },
    {
      "file": "seadrill-report_West-Saturn_2026-06-30.json",
      "rig": "West Saturn",
      "type": "Vendor Surveillance",
      "discipline": "Well Control (WCEG)",
      "wce": "D. Plant",
      "location": "Angola Block 15",
      "date": "2026-06-30",
      "dateEnd": "2026-07-02",
      "exportedAt": "2026-07-02T17:30:00.000Z",
      "modified": "2026-07-02T17:30:00",
      "tileCount": 3,
      "criticalTotal": 0,
      "criticalOpen": 0,
      "actionsTotal": 1,
      "actionsLeftWithRig": 0,
      "criticalItems": [],
      "actionItems": [
        {
          "desc": "Verify vendor torque records for wellhead connector",
          "sys": "Wellhead",
          "resp": "TSL",
          "target": "",
          "deadline": "2026-07-08",
          "leftWithRig": false
        }
      ]
    },
    {
      "file": "seadrill-report_West-Auriga_2026-06-25.json",
      "rig": "West Auriga",
      "type": "Investigation",
      "discipline": "Well Control (WCEG)",
      "wce": "M. Reyes",
      "location": "GoM — Tiber",
      "date": "2026-06-25",
      "dateEnd": "2026-06-29",
      "exportedAt": "2026-06-29T17:30:00.000Z",
      "modified": "2026-06-29T17:30:00",
      "tileCount": 5,
      "criticalTotal": 3,
      "criticalOpen": 2,
      "actionsTotal": 2,
      "actionsLeftWithRig": 1,
      "criticalItems": [
        {
          "done": false,
          "equip": "Blue Pod SEM B",
          "sfi": "333.20",
          "date": "2026-06-25",
          "issue": "Intermittent comms fault",
          "mit": "Troubleshooting ongoing — pod on surface"
        },
        {
          "done": false,
          "equip": "LMRP Connector",
          "sfi": "333.15",
          "date": "2026-06-25",
          "issue": "Secondary unlock function failed test",
          "mit": "Function isolated, OEM engaged"
        },
        {
          "done": true,
          "equip": "Shear Ram Bonnet",
          "sfi": "333.05",
          "date": "2026-06-25",
          "issue": "Seal seep on function test",
          "mit": "Bonnet reseal complete"
        }
      ],
      "actionItems": [
        {
          "desc": "OEM RCA for SEM B comms fault",
          "sys": "MUX Controls",
          "resp": "WCE",
          "target": "",
          "deadline": "2026-07-20",
          "leftWithRig": false
        },
        {
          "desc": "Re-test LMRP secondary unlock after seal kit",
          "sys": "LMRP",
          "resp": "SSS",
          "target": "",
          "deadline": "2026-07-10",
          "leftWithRig": true
        }
      ]
    },
    {
      "file": "seadrill-report_Sevan-Louisiana_2026-06-22.json",
      "rig": "Sevan Louisiana",
      "type": "Operations Support",
      "discipline": "Well Control (WCEG)",
      "wce": "D. Plant",
      "location": "GoM — Salamanca",
      "date": "2026-06-22",
      "dateEnd": "2026-06-24",
      "exportedAt": "2026-06-24T17:30:00.000Z",
      "modified": "2026-06-24T17:30:00",
      "tileCount": 3,
      "criticalTotal": 0,
      "criticalOpen": 0,
      "actionsTotal": 0,
      "actionsLeftWithRig": 0,
      "criticalItems": [],
      "actionItems": []
    },
    {
      "file": "seadrill-report_West-Vela_2026-06-18.json",
      "rig": "West Vela",
      "type": "Technical Inspection",
      "discipline": "Well Control (WCEG)",
      "wce": "M. Reyes",
      "location": "GoM — Whale",
      "date": "2026-06-18",
      "dateEnd": "2026-06-21",
      "exportedAt": "2026-06-21T17:30:00.000Z",
      "modified": "2026-06-21T17:30:00",
      "tileCount": 4,
      "criticalTotal": 0,
      "criticalOpen": 0,
      "actionsTotal": 1,
      "actionsLeftWithRig": 0,
      "criticalItems": [],
      "actionItems": [
        {
          "desc": "Recalibrate riser tensioner sensors",
          "sys": "Tensioners",
          "resp": "Elec Supv",
          "target": "",
          "deadline": "2026-07-01",
          "leftWithRig": false
        }
      ]
    },
    {
      "file": "seadrill-report_West-Neptune_2026-06-15.json",
      "rig": "West Neptune",
      "type": "BWM Compliance",
      "discipline": "Well Control (WCEG)",
      "wce": "D. Plant",
      "location": "GoM — Shenandoah",
      "date": "2026-06-15",
      "dateEnd": "2026-06-19",
      "exportedAt": "2026-06-19T17:30:00.000Z",
      "modified": "2026-06-19T17:30:00",
      "tileCount": 5,
      "criticalTotal": 1,
      "criticalOpen": 0,
      "actionsTotal": 1,
      "actionsLeftWithRig": 1,
      "criticalItems": [
        {
          "done": true,
          "equip": "Upper Annular",
          "sfi": "333.01",
          "date": "2026-06-15",
          "issue": "Element wear at limit",
          "mit": "Replaced on deck"
        }
      ],
      "actionItems": [
        {
          "desc": "Update annular PM interval",
          "sys": "BOP",
          "resp": "SSS",
          "target": "",
          "deadline": "2026-07-15",
          "leftWithRig": true
        }
      ]
    }
  ]
};
