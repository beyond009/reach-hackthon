"reach 0.1";

const [isOutcome, B_WINS, A_WINS] = makeEnum(2);
const [isStatus, PLACE, MOVING] = makeEnum(2);
const line_type = Array(UInt, 3);
const Board_type = Object({
  flag: Bool,
  l1: line_type,
  l2: line_type,
  l3: line_type,
  win: Bool,
});
const newBoard = () => ({
  flag: true,
  l1: Array.replicate(3, 1),
  l2: Array.replicate(3, 0),
  l3: Array.replicate(3, 2),
  win: false,
});
const validStep = (step) => 0 <= step && step < 4;
function placeBoard(place, board) {
  // if (place[2] == 0) {
  // require(validStep(place[0]));
  // require(validStep(pos12));
  // require(validStep(pos21));
  // require(validStep(pos22));
  //   if (place[0] == 0) {
  return {
    flag: !board.flag,
    l1: board.l1,

    // place[2] === 0 && place[0] === 0
    //   ? board.l1.set(place[3], board.l1[place[1]]).set(place[1], 0)
    //   : place[2] === 0
    //   ? board.l1.set(place[3], board.l1[place[1]])
    //   : board.l1,
    l2: board.l2,
    // place[2] == 1 && place[0] == 1
    //   ? board.l2.set(place[3], board.l2[place[1]]).set(place[1], 0)
    //   : place[2] == 1
    //   ? board.l2.set(place[3], board.l2[place[1]])
    //   : board.l2,
    l3: board.l3,
    win: false,
  };
  //   }
  //   if (place[0] == 1) {
  //     return {
  //       flag: !board.flag,
  //       l1: board.l1.set(place[3], board.l2[place[1]]),
  //       l2: board.l2.set(place[1], 0),
  //       l3: board.l3,
  //       win: false,
  //     };
  //   }
  //   if (place[0] == 2) {
  //     return {
  //       flag: !board.flag,
  //       l1: board.l1.set(place[3], board.l3[place[1]]),
  //       l2: board.l2,
  //       l3: board.l3.set(place[1], 0),
  //       win: false,
  //     };
  //   }
  // } else {
  // }
  // if (place[2] == 1) {
  //   if (place[0] == 0) {
  //     return {
  //       flag: !board.flag,
  //       l1: board.l1.set(place[1], 0),
  //       l2: board.l2.set(place[3], board.l1[place[1]]),
  //       l3: board.l3,
  //       win: false,
  //     };
  //   }
  //   if (place[0] == 1) {
  //     return {
  //       flag: !board.flag,
  //       l1: board.l1,
  //       l2: board.l2.set(place[3], board.l2[place[1]]).set(place[1],0),
  //       l3: board.l3,
  //       win: false,
  //     };
  //   }
  //   if (place[0] == 2) {
  //     return {
  //       flag: !board.flag,
  //       l1: board.l1.set(place[3], board.l3[place[1]]),
  //       l2: board.l2,
  //       l3: board.l3.set(place[1], 0),
  //       win: false,
  //     };
  // }
  // if (place[2] == 2) {
  //   if (place[0] == 0) {
  //     return {
  //       flag: !board.flag,
  //       l1: board.l1.set(place[3], board.l1[place[1]]).set(place[1], 0),
  //       l2: board.l2,
  //       l3: board.l3,
  //       win: false,
  //     };
  //   }
  //   if (place[0] == 1) {
  //     return {
  //       flag: !board.flag,
  //       l1: board.l1.set(place[3], board.l2[place[1]]),
  //       l2: board.l2.set(place[1], 0),
  //       l3: board.l3,
  //       win: false,
  //     };
  //   }
  //   if (place[0] == 2) {
  //     return {
  //       flag: !board.flag,
  //       l1: board.l1.set(place[3], board.l3[place[1]]),
  //       l2: board.l2,
  //       l3: board.l3.set(place[1], 0),
  //       win: false,
  //     };
  // }
}
function checkValidPlace(place) {
  //check valid
  return true;
}

function getLine(singleBoard, i, len) {
  return (
    getCell(singleBoard, i) &&
    getCell(singleBoard, add(i, len)) &&
    getCell(singleBoard, i + len + len)
  );
}

// const winner;
function getValidPlace(interact) {
  const place = interact.getPlace();
  assume(checkValidPlace(place));
  return declassify(place);
}

const ROWS = 3;
const COLS = 3;
const CELLS = ROWS * COLS;
const Board = Array(Bool, CELLS);
const State = Object({ xsTurn: Bool, xs: Board, os: Board });

const boardMt = Array.replicate(9, false);

const tttInitial = () => ({
  xsTurn: true,
  xs: boardMt,
  os: boardMt,
});

const cellBoth = (st, i) => st.xs[i] || st.os[i];

const marksAll = (st) => Array.iota(9).map((i) => cellBoth(st, i));

const cell = (r, c) => c + r * COLS;

const op = (op, rhs) => (lhs) => op(lhs, rhs);

const seq = (b, r, c, dr, dc) =>
  b[cell(r, c)] && b[cell(r + dr, dc(c))] && b[cell(r + dr + dr, dc(dc(c)))];

const row = (b, r) => seq(b, r, 0, 0, op(add, 1));
const col = (b, c) => seq(b, 0, c, 1, op(add, 0));

const winningP = (b) =>
  row(b, 0) ||
  row(b, 1) ||
  row(b, 2) ||
  col(b, 0) ||
  col(b, 1) ||
  col(b, 2) ||
  seq(b, 0, 0, 1, op(add, 1)) ||
  seq(b, 0, 2, 1, op(sub, 1));

const completeP = (b) => b.and();

const tttDone = (st) =>
  winningP(st.xs) || winningP(st.os) || completeP(marksAll(st));

const legalMove = (m) => 0 <= m && m < CELLS;
const validMove = (st, m) => !cellBoth(st, m);

function getValidMove(interact, st) {
  const _m = interact.getMove(st);
  assume(legalMove(_m));
  assume(validMove(st, _m));
  return declassify(_m);
}

function applyMove(st, m) {
  require(legalMove(m));
  require(validMove(st, m));
  const turn = st.xsTurn;
  return {
    xsTurn: !turn,
    xs: turn ? st.xs.set(m, true) : st.xs,
    os: turn ? st.os : st.os.set(m, true),
  };
}

const tttWinnerIsX = (st) => winningP(st.xs);
const tttWinnerIsO = (st) => winningP(st.os);

// Protocol

const Player = {
  ...hasRandom,
  getMove: Fun([State], UInt),
  endsWith: Fun([State], Null),
  seeOutcome: Fun([UInt], Null),
  informTimeout: Fun([], Null),
};

export const main = Reach.App(() => {
  const Alice = Participant("Alice", {
    ...Player,
    wager: UInt, // atomic units of currency
    deadline: UInt, // time delta (blocks/rounds)
  });
  const Bob = Participant("Bob", {
    ...Player,
    acceptWager: Fun([UInt], Null),
  });
  deploy();

  const informTimeout = () => {
    each([Alice, Bob], () => {
      interact.informTimeout();
    });
  };

  Alice.only(() => {
    const wager = declassify(interact.wager);
    const deadline = declassify(interact.deadline);
  });
  Alice.publish(wager, deadline).pay(wager);
  commit();

  Bob.only(() => {
    interact.acceptWager(wager);
  });
  Bob.pay(wager).timeout(deadline, () => closeTo(Alice, informTimeout));

  var state = tttInitial();
  invariant(balance() == 2 * wager);
  while (!tttDone(state)) {
    if (state.xsTurn) {
      commit();

      Alice.only(() => {
        const moveA = getValidMove(interact, state);
      });
      Alice.publish(moveA);

      state = applyMove(state, moveA);
      continue;
    } else {
      commit();

      Bob.only(() => {
        const moveB = getValidMove(interact, state);
      });
      Bob.publish(moveB);

      state = applyMove(state, moveB);
      continue;
    }
  }

  const [toA, toB] = tttWinnerIsX(state)
    ? [2, 0]
    : tttWinnerIsO(state)
    ? [0, 2]
    : [1, 1];
  transfer(toA * wager).to(Alice);
  transfer(toB * wager).to(Bob);
  commit();
  const outcome = tttWinnerIsX(state) ? 1 : 0;
  each([Alice, Bob], () => {
    interact.seeOutcome(outcome);
  });
});
