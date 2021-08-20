import React, { useState, useEffect } from "react";

const exports = {};
var last = {
  val: -1,
  pos1: -1,
  pos2: -1,
};
// Player views must be extended.
// It does not have its own Wrapper view.
function Square(props) {
  const [value, setValue] = useState();
  function onClick() {
    if (value) {
      setValue(0);
      last.val = value;
      last.pos1 = props.pos1;
      last.pos2 = props.pos2;
    } else {
      setValue(last.val);
      // props.parent.playPlace([last.pos1, last.pos2, props.pos1, props.pos2]);

      //interact
    }
  }
  useEffect(() => {
    setValue(props.value);
  }, []);
  return (
    <button className="square" onClick={onClick}>
      {value}
    </button>
  );
}

exports.GetPlace = class extends React.Component {
  render() {
    const { parent, playable, board } = this.props;
    return (
      <div>
        <p>hellsxdso</p>
        <div className="board-row">
          {board.l1.map((line, index) => (
            <Square
              value={Number(line._hex)}
              pos1={0}
              pos2={index}
              parent={parent}
            ></Square>
          ))}
        </div>
        <div className="board-row">
          {board.l2.map((line, index) => (
            <Square
              value={Number(line._hex)}
              pos1={1}
              pos2={index}
              parent={parent}
            ></Square>
          ))}
        </div>
        <div className="board-row">
          {board.l3.map((line, index) => (
            <Square
              value={Number(line._hex)}
              pos1={2}
              pos2={index}
              parent={parent}
            ></Square>
          ))}
        </div>
      </div>
    );
  }
};

exports.WaitingForResults = class extends React.Component {
  render() {
    return <div>Waiting for results...</div>;
  }
};

exports.Done = class extends React.Component {
  render() {
    const { outcome } = this.props;
    return (
      <div>
        Thank you for playing. The outcome of this game was:
        <br />
        {outcome || "Unknown"}
      </div>
    );
  }
};

exports.Timeout = class extends React.Component {
  render() {
    return <div>There's been a timeout. (Someone took too long.)</div>;
  }
};

class Board extends React.Component {
  renderSquare(i) {
    return <Square value={1} onClick={() => this.props.onClick(i)}></Square>;
  }

  render() {
    return (
      <div>
        <div className="board-row">
          {this.renderSquare(0)}
          {this.renderSquare(1)}
          {this.renderSquare(2)}
        </div>
        <div className="board-row">
          {this.renderSquare(3)}
          {this.renderSquare(4)}
          {this.renderSquare(5)}
        </div>
        <div className="board-row">
          {this.renderSquare(6)}
          {this.renderSquare(7)}
          {this.renderSquare(8)}
        </div>
      </div>
    );
  }
}

export default exports;
