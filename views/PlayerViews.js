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
  return (
    <button className="square" onClick={props.onClick}>
      {props.value}
    </button>
  );
}

exports.GetMove = class extends React.Component {
  constructor(props) {
    super(props);
    const { parent, playable, board } = this.props;
    console.log(board);
    this.state = {
      board: board,
      old_board: board,
      parent: parent,
      place: -1,
    };
  }
  check(board, i) {
    return board.os || board.xs[i];
  }
  handleClick(i) {
    if (this.state.board.turn && !this.check(this.state.board, i)) {
      const board = JSON.parse(JSON.stringify(this.state.old_board));
      board.xs[i] = true;
      this.setState({ board: board, place: i });
    } else if (!this.check(this.state.board, i)) {
      const board = JSON.parse(JSON.stringify(this.state.old_board));
      board.os[i] = true;
      this.setState({ board: board, place: i });
    }
    this.state.parent.playPlace(i);
  }
  renderValue(i) {
    if (this.state.board.os[i] || this.state.old_board.os[i]) {
      return "B";
    } else if (this.state.board.xs[i] || this.state.old_board.xs[i]) {
      return "A";
    } else {
      return null;
    }
  }
  renderSquare(i) {
    return (
      <Square
        value={this.renderValue(i)}
        onClick={() => this.handleClick(i)}
        old={this.check(this.state.old_board, i)}
      ></Square>
    );
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
          {/* <Square
            value={this.renderValue()}
            pos1={1}
            pos2={index}
            parent={parent}
          ></Square>
          <Square
            value={Number(line._hex)}
            pos1={1}
            pos2={index}
            parent={parent}
          ></Square>
          <Square
            value={Number(line._hex)}
            pos1={1}
            pos2={index}
            parent={parent}
          ></Square> */}
        </div>
        <div className="board-row">
          {this.renderSquare(6)}
          {this.renderSquare(7)}
          {this.renderSquare(8)}
          {/* {board.l3.map((line, index) => (
            <Square
              value={Number(line._hex)}
              pos1={2}
              pos2={index}
              parent={parent}
            ></Square>
          ))} */}
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
