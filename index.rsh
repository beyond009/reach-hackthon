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

function isWin(singleBoard) {
  return (
    getLine(singleBoard, 0, 1) ||
    getLine(singleBoard, 3, 1) ||
    getLine(singleBoard, 6, 1) ||
    getLine(singleBoard, 0, 3) ||
    getLine(singleBoard, 1, 3) ||
    getLine(singleBoard, 2, 3) ||
    getLine(singleBoard, 0, 4) ||
    getLine(singleBoard, 2, 2)
  );
}
// const winner;
function getValidPlace(interact) {
  const place = interact.getPlace();
  assume(checkValidPlace(place));
  return declassify(place);
}

const Player = {
  ...hasRandom,
  getPlace: Fun([], Array(UInt, 4)),
  seeBoard: Fun([Board_type], Null),
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
  //waget finish
  var board = newBoard();
  invariant(balance() == 2 * wager);
  // each([Alice, Bob], () => {
  //   interact.seeBoard(board);
  // });

  while (true) {
    each([Alice, Bob], () => {
      interact.seeBoard(board);
    });
    if (board.flag) {
      commit();
      Alice.only(() => {
        const placeAlice = getValidPlace(interact);
      });
      Alice.publish(placeAlice).timeout(deadline, () =>
        closeTo(Bob, informTimeout)
      );
      board = placeBoard(placeAlice, board);
      continue;
    } else {
      commit();
      Bob.only(() => {
        const placeBob = getValidPlace(interact);
      });
      Bob.publish(placeBob).timeout(deadline, () =>
        closeTo(Alice, informTimeout)
      );
      board = placeBoard(placeBob, board);
      continue;
    }
    if (isWin()) {
      const outcome = isWinner() ? A_WINS : B_WINS;
      break;
    }
  }
  // assert(outcome == A_WINS || outcome == B_WINS);
  transfer(2 * wager).to(outcome == A_WINS ? Alice : Bob);
  commit();

  each([Alice, Bob], () => {
    interact.seeOutcome(outcome);
  });
});
