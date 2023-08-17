import React, { useState } from "react";
import { token } from "../../../declarations/token";
import { Principal } from "@dfinity/principal";

function Transfer() {
  const [toAccount, setTo] = useState("");
  const [amount, setAmount] = useState("");
  const [isHidden, setHidden] = useState(false);
  const [isDisabled, setDisabled] = useState(true);
  const [feedback, setFeedback] = useState("");

  async function handleClick() {
    setHidden(true);
    const to = Principal.fromText(toAccount);
    const amountToTransfor = Number(amount);
    const result = await token.transfer(to, amountToTransfor);
    setFeedback(result);
    setDisabled(false);
    setHidden(false);
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value={toAccount}
                onChange={(e) => {
                  setTo(e.target.value);
                }}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value={amount}
                onChange={(e) => {
                  setAmount(e.target.value);
                }}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button id="btn-transfer" onClick={handleClick} disabled={isHidden}>
            Transfer
          </button>
        </p>
        <p hidden={isDisabled}> {feedback}</p>
      </div>
    </div>
  );
}

export default Transfer;
