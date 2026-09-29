// Builds the three Roughneck Fitness training plans as .docx.
// Usage: node build-plans.js <outdir>   (needs the `docx` npm package, v9)
// The plans are drafts for the coach to review and sign off as the qualified person.
const fs = require('fs'), path = require('path');
const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, WidthType, AlignmentType, BorderStyle, ShadingType, HeadingLevel, PageBreak, Footer, Header, PageNumber } = require('docx');

const OUT = process.argv[2] || '.';
const ORANGE = 'FF6A13', STEEL = '14171A', MUTE = '6B7280', CHALK = 'F3F1EC', LINE = 'D0D4DA';
const FONT = 'Arial';

// ---------- helpers ----------
const t = (text, o = {}) => new TextRun({ text, font: FONT, size: o.size || 21, bold: o.bold, color: o.color, italics: o.italics });
const P = (children, o = {}) => new Paragraph({ children: Array.isArray(children) ? children : [t(children, o)], spacing: { after: o.after ?? 120, before: o.before ?? 0 }, alignment: o.align });
const H1 = (s) => new Paragraph({ children: [t(s.toUpperCase(), { size: 40, bold: true, color: STEEL })], spacing: { before: 360, after: 120 } });
const H2 = (s) => new Paragraph({ children: [t(s.toUpperCase(), { size: 26, bold: true, color: ORANGE })], spacing: { before: 280, after: 100 } });
const label = (s) => new Paragraph({ children: [t(s.toUpperCase(), { size: 16, bold: true, color: MUTE })], spacing: { after: 60 } });
const bullet = (s) => new Paragraph({ children: [t(s)], bullet: { level: 0 }, spacing: { after: 60 } });
const rule = () => new Paragraph({ border: { bottom: { style: BorderStyle.SINGLE, size: 12, color: ORANGE } }, spacing: { after: 200 } });
const brk = () => new Paragraph({ children: [new PageBreak()] });
const border = { style: BorderStyle.SINGLE, size: 4, color: LINE };
const borders = { top: border, bottom: border, left: border, right: border };
function cell(text, o = {}) {
  return new TableCell({ borders, width: o.w ? { size: o.w, type: WidthType.PERCENTAGE } : undefined,
    shading: o.head ? { type: ShadingType.CLEAR, fill: STEEL } : (o.shade ? { type: ShadingType.CLEAR, fill: CHALK } : undefined),
    margins: { top: 70, bottom: 70, left: 100, right: 100 },
    children: [new Paragraph({ children: [t(text, { size: o.size || 19, bold: o.head || o.bold, color: o.head ? 'FFFFFF' : undefined })] })] });
}
function table(head, rows, widths) {
  return new Table({ width: { size: 100, type: WidthType.PERCENTAGE },
    rows: [new TableRow({ tableHeader: true, children: head.map((h, i) => cell(h, { head: true, w: widths[i] })) }),
      ...rows.map((r, ri) => new TableRow({ children: r.map((c, i) => cell(c, { w: widths[i], shade: ri % 2 === 1, bold: i === 0 })) }))] });
}
function session(s) {
  return [H2(s.name), P(s.note, { color: MUTE, size: 19, after: 100 }),
    table(['Exercise', 'Sets', 'Reps', 'Rest', 'Notes'], s.ex.map(e => [e[0], e[1], e[2], e[3], e[4] || '']), [34, 8, 12, 10, 36])];
}

// ---------- shared content ----------
const howToUse = (plan) => [
  H1('How to use this plan'),
  P(`Four weeks. ${plan.days} training days a week, ${plan.duration} a session. Run it once, then run it again with the progression rules below. Two rounds is eight weeks, which is long enough to see a real change if the diet section is followed too.`),
  H2('The three rules'),
  bullet('Same exercises, same order, every week. The plan only works if you can compare week 3 to week 1.'),
  bullet('Progression: when you hit the top of the rep range on every set with good form, add weight next time (2.5 kg upper body, 5 kg lower body, or the next dumbbell up). If you can\'t, keep the weight and add a rep.'),
  bullet('RPE 8 on working sets: two reps left in the tank. Not to failure, not easy. If you could do five more, it\'s too light.'),
  H2('Warm-up, every session, five minutes'),
  bullet('Two minutes easy: bike, row, or march on the spot.'),
  bullet('Ten arm circles each way, ten leg swings each leg, ten bodyweight squats, ten band pull-aparts or scapular push-ups.'),
  bullet('First exercise of the day: two light sets before the working sets.'),
  H2('Missed a session?'),
  P('Do the next one on the list. Don\'t double up and don\'t restart the week. A week with two sessions beats a week with none, and the plan doesn\'t care what day it is.'),
  H2('Tracking'),
  P('Weigh yourself first thing, after the toilet, before food, on the same scales, four mornings a week. Use the weekly average, never a single day. Photos every Sunday: same mirror, same light, same pose. The tracking sheet is at the back.'),
];

const diet = (plan) => [
  brk(), H1('Diet guide'),
  P('Training builds it. Food decides whether you see it. This section is the same across all three plans, with a page of food advice specific to where you are.', { color: MUTE }),
  H2('1. Calories: the only number that decides fat loss'),
  P('Estimate maintenance as bodyweight in kg × 30. To lose fat, eat 400 to 500 below that. To build muscle without a gut, eat 150 to 250 above it. Examples:'),
  table(['Bodyweight', 'Maintenance (approx.)', 'Fat loss', 'Lean gain'], [
    ['80 kg', '2,400 kcal', '1,900 to 2,000', '2,550 to 2,650'],
    ['95 kg', '2,850 kcal', '2,350 to 2,450', '3,000 to 3,100'],
    ['110 kg', '3,300 kcal', '2,800 to 2,900', '3,450 to 3,550'],
  ], [22, 30, 24, 24]),
  P('These are starting points, not laws. Hold the number for two weeks, look at the weekly average on the scales, then adjust by 200 kcal. Losing 0.5 to 1 per cent of bodyweight a week is the target. Faster than that and you\'re losing muscle.', { before: 120 }),
  H2('2. Protein: the number that keeps the muscle'),
  P('1.8 to 2.2 g per kg of bodyweight, every day, split across three or four meals. A 95 kg man needs 170 to 210 g. That is roughly: 40 g at each of four meals. Sources that hit 30 to 40 g without thinking: 150 g chicken breast, 200 g lean mince, two tins of tuna, 250 g Greek yoghurt plus a scoop of whey, five eggs, 200 g cottage cheese.'),
  H2('3. Everything else'),
  bullet('Carbs around training. The meal before and after a session is where the bread, rice, potatoes and oats go. On rest days, less.'),
  bullet('Fats: some every day, mostly from eggs, oily fish, olive oil, nuts. Not the thing to cut to zero.'),
  bullet('Vegetables: two fistfuls at two meals a day. Not for the calories, for the fullness and for feeling human.'),
  bullet('Water: three litres a day, more if you\'re sweating at work. Most "hunger" at 3 pm is thirst.'),
  bullet('Sleep: seven hours is part of the diet. Under six and hunger hormones go up, willpower goes down.'),
  H2('4. The plate, when you can\'t count'),
  P('Half the plate vegetables or salad. A quarter protein, palm-sized. A quarter carbs, fist-sized. A thumb of fat. Two plates like that a day plus a protein-heavy breakfast lands most men close to their fat-loss number without an app.'),
  H2('5. Alcohol'),
  P('Every drink is 100 to 250 empty calories and switches fat burning off for hours. Two nights a week of "a few" is 2,000 calories, which is a whole day\'s food and the reason the scales don\'t move. If you\'re cutting down: decide the number before you go out, alternate with water, eat first. If you\'ve stopped: the first month is where the weight falls off, and that is not a coincidence.'),
  H2('6. Supplements worth the money'),
  bullet('Whey protein: convenient, not magic. Use it to hit the protein number.'),
  bullet('Creatine monohydrate, 5 g a day, any time. The only supplement with decades of evidence for strength and muscle.'),
  bullet('Vitamin D in a UK winter, and if you work nights or indoors.'),
  bullet('Everything else: fat burners, test boosters, BCAAs, greens powders. Save the money.'),
  ...plan.food,
];

const tracking = (plan) => [
  brk(), H1('Tracking sheet'),
  P('Print it or copy it into your notes. Fill it in every week. Weight is the average of your four morning weigh-ins.', { color: MUTE }),
  table(['Week', 'Avg weight', ...plan.sessions.map(s => s.short), 'Photos', 'Notes'],
    [1, 2, 3, 4, 5, 6, 7, 8].map(w => [`Week ${w}`, '', ...plan.sessions.map(() => ''), '', '']),
    [10, 12, ...plan.sessions.map(() => Math.floor(48 / plan.sessions.length)), 10, 20]),
  H2('Lift log'),
  P('Top set only: weight × reps. Progress is this column going up.', { color: MUTE }),
  table(['Exercise', 'Wk 1', 'Wk 2', 'Wk 3', 'Wk 4', 'Wk 5', 'Wk 6', 'Wk 7', 'Wk 8'],
    plan.keyLifts.map(l => [l, '', '', '', '', '', '', '', '']), [28, 9, 9, 9, 9, 9, 9, 9, 9]),
];

const safety = () => [
  brk(), H1('Read this'),
  bullet('This plan is written for healthy adults. If you have a heart condition, high blood pressure, an injury, are on medication, or have been drinking heavily until recently, see a GP before you start. That is not a legal line, it is what the coach did.'),
  bullet('Pain is not the same as effort. Sharp pain, joint pain, or anything that gets worse set by set: stop that exercise, do the alternative in the notes, and tell the coach.'),
  bullet('The diet section is general guidance, not a prescription. Anyone with a medical condition affecting diet (diabetes, kidney issues, an eating disorder history) should follow their clinician\'s advice over this document.'),
  bullet('Results shown on the website are one person\'s. Yours depend on what you do with this.'),
  P(''),
  P('Roughneck Fitness · roughneckfitness.com · coach@roughneckfitness.com', { color: MUTE, size: 18 }),
];

// ---------- the three plans ----------
const PLANS = [
  {
    file: 'Roughneck-Plan-Full-Gym.docx', title: 'Full Gym', sub: 'Four days a week · full rack, cables and machines · 60 minutes',
    days: 'four', duration: '55 to 65 minutes',
    intro: 'The plan that built the after photos. Upper and lower body twice each a week, heavy compound lifts first, the shaping work after. Built for a commercial gym or a well-kitted home gym.',
    schedule: [['Monday', 'Upper A'], ['Tuesday', 'Lower A'], ['Wednesday', 'Rest or 30 min walk'], ['Thursday', 'Upper B'], ['Friday', 'Lower B'], ['Saturday', 'Optional: 20 min conditioning'], ['Sunday', 'Rest, photos, weigh-in average']],
    sessions: [
      { name: 'Upper A', short: 'Up A', note: 'Press-led. Rest 2 to 3 minutes on the first two lifts, 60 to 90 seconds on the rest.', ex: [
        ['Barbell bench press', '4', '5 to 8', '2 to 3 min', 'Feet planted, bar to lower chest. Alternative: machine chest press'],
        ['Chest-supported row (machine or incline DB)', '4', '8 to 12', '2 min', 'Pull to lower ribs, squeeze one second'],
        ['Seated dumbbell shoulder press', '3', '8 to 12', '90 s', 'Elbows slightly forward, not flared'],
        ['Lat pulldown, wide', '3', '10 to 12', '90 s', 'Chest up, pull elbows down to pockets'],
        ['Cable lateral raise', '3', '12 to 15', '60 s', 'Slight lean away, lead with the elbow'],
        ['Cable triceps pushdown', '3', '12 to 15', '60 s', 'Elbows pinned'],
        ['Incline dumbbell curl', '3', '10 to 12', '60 s', 'Full stretch at the bottom'],
      ]},
      { name: 'Lower A', short: 'Lo A', note: 'Squat-led. Take the leg press to two reps in reserve, not to the point of grinding.', ex: [
        ['Barbell back squat', '4', '5 to 8', '3 min', 'Alternative: hack squat or leg press'],
        ['Romanian deadlift', '3', '8 to 10', '2 to 3 min', 'Hips back, bar on the thighs, stop when hamstrings say so'],
        ['Leg press', '3', '10 to 12', '2 min', 'Feet mid-platform, full depth without the lower back rounding'],
        ['Walking lunge (dumbbells)', '3', '10 each leg', '90 s', 'Long steps, upright torso'],
        ['Seated leg curl', '3', '12 to 15', '60 s', 'Slow on the way back'],
        ['Standing calf raise', '4', '10 to 15', '60 s', 'Pause at the bottom, full stretch'],
        ['Hanging knee raise or cable crunch', '3', '12 to 15', '60 s', ''],
      ]},
      { name: 'Upper B', short: 'Up B', note: 'Pull-led. Different angles from Upper A so nothing gets beaten up twice the same way.', ex: [
        ['Weighted pull-up or assisted pull-up', '4', '6 to 10', '2 to 3 min', 'Alternative: neutral-grip pulldown'],
        ['Incline dumbbell press', '4', '8 to 12', '2 min', '30 degree bench'],
        ['Single-arm dumbbell row', '3', '10 to 12', '90 s', 'Pull to the hip, not the shoulder'],
        ['Machine shoulder press', '3', '10 to 12', '90 s', ''],
        ['Cable fly or pec deck', '3', '12 to 15', '60 s', 'Stretch at the back, squeeze at the front'],
        ['Face pull', '3', '15 to 20', '60 s', 'Rope to the forehead, thumbs back'],
        ['EZ-bar curl', '3', '10 to 12', '60 s', ''],
        ['Overhead cable triceps extension', '3', '12 to 15', '60 s', ''],
      ]},
      { name: 'Lower B', short: 'Lo B', note: 'Hinge-led. The deadlift is the one lift where form beats weight every single time.', ex: [
        ['Trap-bar or conventional deadlift', '4', '4 to 6', '3 min', 'Alternative: heavy Romanian deadlift'],
        ['Bulgarian split squat', '3', '8 to 10 each', '2 min', 'Rear foot on a bench, front shin vertical'],
        ['Hack squat or front squat', '3', '8 to 12', '2 min', ''],
        ['Lying leg curl', '3', '10 to 12', '90 s', ''],
        ['Leg extension', '3', '12 to 15', '60 s', 'Hold the top for one second'],
        ['Seated calf raise', '4', '12 to 15', '60 s', ''],
        ['Plank', '3', '45 to 60 s', '60 s', 'Squeeze glutes, don\'t sag'],
      ]},
    ],
    keyLifts: ['Bench press', 'Back squat', 'Deadlift', 'Pull-up', 'Shoulder press', 'Romanian deadlift'],
    food: [
      H2('7. Food at home: the full-gym week'),
      P('You have a kitchen, so use it once and eat all week. Sunday: cook two kilos of protein (chicken thighs, lean mince, salmon), a tray of roasted vegetables, a pan of rice or potatoes. Portion into boxes. That is four days of lunches done, and the takeaway on Wednesday stops being the easy option because the box is easier.'),
      bullet('Breakfast that hits 40 g protein: four eggs and two slices of toast, or 250 g Greek yoghurt with a scoop of whey and oats.'),
      bullet('Post-training: protein plus the biggest carb meal of the day. This is where the rice goes.'),
      bullet('Supermarket rule: if it comes in a packet with a cartoon on it, it isn\'t food.'),
      bullet('Weekend: eat the same way Saturday. Sunday is the one meal where you don\'t count, and it\'s one meal, not one day.'),
    ],
  },
  {
    file: 'Roughneck-Plan-Rig-and-Site.docx', title: 'Rig & Site', sub: 'Three days a week · rack, dumbbells, one cable stack · 45 minutes',
    days: 'three', duration: '40 to 50 minutes',
    intro: 'Written for a container gym: a rack, a bench, dumbbells to 40 kg, one cable stack, maybe a bike. Full-body sessions so that missing one on a heavy shift day costs you nothing. Every exercise has a swap for when the kit isn\'t there or someone else is using it.',
    schedule: [['Day 1', 'Full body A'], ['Day 2', 'Off or 20 min walk on deck'], ['Day 3', 'Full body B'], ['Day 4', 'Off'], ['Day 5', 'Full body C'], ['Day 6', 'Optional: 15 min bike intervals'], ['Day 7', 'Off, weigh-in average, photos']],
    sessions: [
      { name: 'Full body A', short: 'FB A', note: 'Squat, press, pull. If the rack is taken, start with the dumbbell exercises and come back to it.', ex: [
        ['Goblet squat or barbell back squat', '4', '8 to 10', '2 min', 'Goblet with the heaviest dumbbell if no rack'],
        ['Dumbbell bench press', '4', '8 to 12', '2 min', 'Flat bench. Swap: floor press'],
        ['Single-arm dumbbell row', '4', '10 to 12 each', '90 s', 'Hand on the bench'],
        ['Dumbbell Romanian deadlift', '3', '10 to 12', '90 s', 'Slow on the way down'],
        ['Cable or band face pull', '3', '15 to 20', '60 s', 'Shoulder health on a job that wrecks shoulders'],
        ['Dumbbell hammer curl', '3', '10 to 12', '60 s', ''],
        ['Plank', '3', '45 s', '45 s', ''],
      ]},
      { name: 'Full body B', short: 'FB B', note: 'Hinge, overhead press, vertical pull. The deadlift can be trap bar, barbell or two heavy dumbbells.', ex: [
        ['Deadlift (barbell, trap bar or dumbbells)', '4', '6 to 8', '2 to 3 min', 'Back flat, bar close'],
        ['Standing dumbbell shoulder press', '4', '8 to 10', '2 min', 'Brace the core, don\'t lean back'],
        ['Lat pulldown or pull-up', '4', '8 to 12', '90 s', 'Swap: band-assisted pull-up on the rack'],
        ['Dumbbell reverse lunge', '3', '10 each', '90 s', ''],
        ['Dumbbell lateral raise', '3', '12 to 15', '60 s', ''],
        ['Cable triceps pushdown or bench dip', '3', '12 to 15', '60 s', ''],
        ['Hanging knee raise on the rack', '3', '10 to 15', '60 s', ''],
      ]},
      { name: 'Full body C', short: 'FB C', note: 'Higher reps, shorter rests. The session that works after a bad night\'s sleep because nothing is heavy.', ex: [
        ['Dumbbell step-up onto the bench', '3', '10 each', '90 s', 'Drive through the heel'],
        ['Incline dumbbell press', '3', '10 to 12', '90 s', 'Prop the bench on a plate if it doesn\'t incline'],
        ['Chest-supported dumbbell row (on incline bench)', '3', '12 to 15', '90 s', ''],
        ['Dumbbell goblet squat', '3', '12 to 15', '90 s', ''],
        ['Cable or band pull-apart', '3', '20', '45 s', ''],
        ['Dumbbell curl to press', '3', '10 to 12', '60 s', 'Two exercises in one when time is short'],
        ['Bike or rower', '1', '10 min', '', '30 s hard, 60 s easy, repeat'],
      ]},
    ],
    keyLifts: ['Squat (goblet or bar)', 'Dumbbell bench', 'Deadlift', 'Shoulder press', 'Row', 'Pulldown or pull-up'],
    food: [
      H2('7. Food on the rig: the galley'),
      P('The galley will feed you 5,000 calories a day if you let it, and every one of them is free. The trick is that it also serves everything you need. You just have to walk past the first two-thirds of the counter.'),
      bullet('Breakfast: eggs, however they come, plus beans or tomatoes. Skip the fried bread, hash browns and sausages. Porridge if there\'s a long shift ahead.'),
      bullet('Main meals: the plain protein (grilled chicken, fish, roast meat, steak night), potatoes or rice not chips, and two ladles of vegetables. Sauce on the side.'),
      bullet('The salad bar is the most underrated thing on a rig. Load it with tuna, eggs, cottage cheese, chicken. That\'s a 50 g protein meal.'),
      bullet('Night shift: eat the main meal at the start of the shift, something light and protein-based halfway, nothing in the last two hours before bed.'),
      bullet('The tea shack: one biscuit is 80 calories. The tin is 1,500. Keep whey sachets in your locker for the 3 am hunger instead.'),
      bullet('Crew change: the airport and the first night home are where two weeks of work get thrown away. Eat before the flight, and decide what the first night looks like before you land.'),
    ],
  },
  {
    file: 'Roughneck-Plan-Hotel.docx', title: 'Hotel', sub: 'Three or four days a week · bodyweight, one band, hotel-gym dumbbells · 35 minutes',
    days: 'three or four', duration: '30 to 40 minutes',
    intro: 'For the weeks on the road. Assumes nothing beyond your own bodyweight, one resistance band that lives in your bag, and a hotel gym with dumbbells to about 20 kg if you\'re lucky. Every session has a no-gym version that works in the room.',
    schedule: [['Day 1', 'Push and legs'], ['Day 2', 'Off or 30 min walk (skip the taxi)'], ['Day 3', 'Pull and core'], ['Day 4', 'Off'], ['Day 5', 'Full body circuit'], ['Day 6', 'Optional: repeat Day 1'], ['Day 7', 'Off, weigh-in on whatever scales the hotel has, photos']],
    sessions: [
      { name: 'Push and legs', short: 'Push', note: 'Hotel gym if there is one; the room version is in the last column.', ex: [
        ['Dumbbell goblet squat (room: bodyweight squat, slow, 3 s down)', '4', '12 to 15', '75 s', 'Heaviest dumbbell they\'ve got'],
        ['Push-up, feet raised on the bed or chair', '4', '10 to 20', '75 s', 'Room: same. Add a pause at the bottom when 20 is easy'],
        ['Dumbbell shoulder press (room: band overhead press)', '3', '10 to 15', '60 s', ''],
        ['Bulgarian split squat, rear foot on the bed', '3', '10 to 12 each', '75 s', 'Hold dumbbells if available'],
        ['Band or dumbbell lateral raise', '3', '15 to 20', '45 s', ''],
        ['Bench dip on the chair', '3', '12 to 15', '45 s', 'Shoulders down, not shrugged'],
        ['Wall sit', '3', '45 to 60 s', '45 s', ''],
      ]},
      { name: 'Pull and core', short: 'Pull', note: 'The band earns its place here. Anchor it in the door hinge side, high, and check the door is locked.', ex: [
        ['Band row, seated on the floor or standing from the door', '4', '15 to 20', '60 s', 'Dumbbell row if the gym has a bench'],
        ['Band lat pulldown (kneeling, band over the door)', '4', '15 to 20', '60 s', 'Pull-ups on the hotel gym rack if one exists'],
        ['Single-arm dumbbell row (room: band row, one arm)', '3', '12 to 15 each', '60 s', ''],
        ['Band face pull', '3', '20', '45 s', ''],
        ['Band or dumbbell curl', '3', '15 to 20', '45 s', ''],
        ['Dead bug', '3', '10 each side', '45 s', 'Lower back flat on the floor'],
        ['Side plank', '3', '30 to 45 s each', '45 s', ''],
      ]},
      { name: 'Full body circuit', short: 'Circuit', note: 'Six exercises back to back, rest 90 s, repeat four times. Twenty-five minutes, done. Also the fallback session for any day the plan falls apart.', ex: [
        ['Bodyweight squat', '4 rounds', '15', 'none', 'Circuit: move straight to the next exercise'],
        ['Push-up', '4 rounds', '12', 'none', ''],
        ['Reverse lunge', '4 rounds', '10 each', 'none', ''],
        ['Band row', '4 rounds', '15', 'none', ''],
        ['Mountain climber', '4 rounds', '20 each', 'none', ''],
        ['Plank', '4 rounds', '40 s', '90 s', 'Then rest and go again'],
      ]},
    ],
    keyLifts: ['Push-ups in one set', 'Goblet squat', 'Band row', 'Split squat', 'Plank hold (seconds)', 'Circuit rounds completed'],
    food: [
      H2('7. Food on the road: hotels, restaurants, airports'),
      P('Travel food fails in two ways: the buffet breakfast and the "I\'ve had a long day" dinner with a drink. Both are solved by deciding in advance.'),
      bullet('Buffet breakfast: eggs and whatever protein is out (ham, smoked salmon, cheese), fruit, yoghurt. One plate, one trip. The pastries are 400 calories each and you won\'t remember eating them.'),
      bullet('Restaurant: the grilled thing with vegetables, sauce on the side, swap chips for potatoes or salad. Any restaurant will do this, you just have to ask. Order first so nobody talks you into the burger.'),
      bullet('Room service: steak, chicken or fish plus a side of vegetables. Nothing that comes with "loaded" in the name.'),
      bullet('Airport: a supermarket meal deal with a protein pot beats anything hot. Drink a litre of water on the flight, not the free wine.'),
      bullet('Carry: whey sachets, a shaker, and a bag of nuts or jerky. That covers the 4 pm gap in every country.'),
      bullet('Alcohol on the road is the biggest one. Hotel bars are built for it. Decide before you check in: none, or one, and go to the gym at the time you\'d usually be at the bar.'),
    ],
  },
];

// ---------- build ----------
function build(plan) {
  const children = [
    // cover
    new Paragraph({ children: [t('ROUGHNECK FITNESS', { size: 22, bold: true, color: ORANGE })], spacing: { before: 2400, after: 100 } }),
    new Paragraph({ children: [t(plan.title.toUpperCase(), { size: 72, bold: true, color: STEEL })], spacing: { after: 60 } }),
    new Paragraph({ children: [t('TRAINING PLAN', { size: 40, bold: true, color: STEEL })], spacing: { after: 200 } }),
    rule(),
    P(plan.sub, { size: 24, color: MUTE, after: 400 }),
    P(plan.intro, { size: 22, after: 600 }),
    P('Four-week programme · diet guide included · tracking sheet at the back', { size: 18, color: MUTE }),
    P('DRAFT FOR COACH REVIEW. Not for sale until the coach has read and signed off every exercise, rep range and diet line.', { size: 18, bold: true, color: ORANGE }),
    brk(),
    ...howToUse(plan),
    H2('The week'),
    table(['Day', 'Session'], plan.schedule, [30, 70]),
    brk(),
    H1('The sessions'),
    ...plan.sessions.flatMap(session),
    ...diet(plan),
    ...tracking(plan),
    ...safety(),
  ];
  return new Document({
    creator: 'Roughneck Fitness', title: `${plan.title} training plan`,
    styles: { default: { document: { run: { font: FONT, size: 21 } } } },
    sections: [{
      properties: { page: { margin: { top: 1100, bottom: 1000, left: 1100, right: 1100 } } },
      headers: { default: new Header({ children: [new Paragraph({ children: [t(`ROUGHNECK FITNESS · ${plan.title.toUpperCase()} PLAN`, { size: 16, bold: true, color: MUTE })] })] }) },
      footers: { default: new Footer({ children: [new Paragraph({ alignment: AlignmentType.RIGHT, children: [t('Page ', { size: 16, color: MUTE }), new TextRun({ children: [PageNumber.CURRENT], font: FONT, size: 16, color: MUTE })] })] }) },
      children,
    }],
  });
}

(async () => {
  fs.mkdirSync(OUT, { recursive: true });
  for (const plan of PLANS) {
    const buf = await Packer.toBuffer(build(plan));
    fs.writeFileSync(path.join(OUT, plan.file), buf);
    console.log('wrote', plan.file);
  }
})();
