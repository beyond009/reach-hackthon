"reach 0.1";

const [isOutcome, B_WINS, DRAW, A_WINS] = makeEnum(3);
const [isStatus, PLACE, MOVING] = makeEnum(2);
const board = [
  [1, 0, 0, 1, 0, 0, 1],
  [0, 1, 0, 1, 0, 1, 0],
  [0, 0, 1, 1, 1, 0, 0],
  [1, 1, 1, 0, 1, 1, 1],
  [0, 0, 1, 1, 1, 0, 0],
  [0, 1, 0, 1, 0, 1, 0],
  [1, 0, 0, 1, 0, 0, 1],
];
// const winner;
function getValidPlace(interact) {
  const place = interact.getPlace(board);
  assume(checkValidPlace(place));
  return declassify(place);
}

forall(UInt, (handA) =>
  forall(UInt, (handB) => assert(isOutcome(winner(handA, handB))))
);

forall(UInt, (hand) => assert(winner(hand, hand) == DRAW));

const Player = {
  ...hasRandom,
  getPlace: Fun([], UInt),
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
  var status = PLACE;
  invariant(balance() == 2 * wager);
  while (outcome == PLACE) {
    commit();
    Alice.only(() => {
      const placeAlice = getValidPlace(interact);
    });
    Alice.publish(placeAlice).timeout(deadline, () =>
      closeTo(Bob, informTimeout)
    );
    commit();
    Bob.only(() => {
      const placeBob = getValidPlace(interact);
    });
    Bob.publish(handBob).timeout(deadline, () => closeTo(Alice, informTimeout));
    commit();

    Alice.only(() => {
      const saltAlice = declassify(_saltAlice);
      const handAlice = declassify(_handAlice);
    });
    Alice.publish(saltAlice, handAlice).timeout(deadline, () =>
      closeTo(Bob, informTimeout)
    );
    checkCommitment(commitAlice, saltAlice, handAlice);

    //outcome
    continue;
  }

  assert(outcome == A_WINS || outcome == B_WINS);
  transfer(2 * wager).to(outcome == A_WINS ? Alice : Bob);
  commit();

  each([Alice, Bob], () => {
    interact.seeOutcome(outcome);
  });
});
